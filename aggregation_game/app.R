# 🎤 Taylor Swift Aggregation Game ----------------------------------------
#
# A Shiny app for Catalina's FAU module (Day 4 — Random Forest session).
# Demonstrates the wisdom of crowds (Condorcet Jury Theorem) before
# introducing Random Forest.
#
# Students individually guess how many people attended a Taylor Swift
# Eras Tour show in Pittsburgh. The mean of all guesses converges to
# the truth — even though no individual gets it right.
#
# How to run locally:
#   shiny::runApp()
#
# How to deploy to shinyapps.io:
#   1. install.packages(c("rsconnect", "shiny", "bslib", "ggplot2", "dplyr"))
#   2. rsconnect::setAccountInfo(name = "...", token = "...", secret = "...")
#   3. rsconnect::deployApp("aggregation_game")
#
# Admin/instructor controls (append to the URL):
#   ?admin=true     →  show "Reveal truth" and "Reset all" buttons

library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)

# ---- Constants -----------------------------------------------------------

GUESSES_FILE <- "guesses.csv"

# Pittsburgh Acrisure Stadium, June 16 & 17, 2023.
# Source: https://en.wikipedia.org/wiki/The_Eras_Tour
TRUE_ATTENDANCE <- 73117
EVENT_NAME      <- "Acrisure Stadium, Pittsburgh — Eras Tour, June 2023"

# ---- Helpers -------------------------------------------------------------

ensure_file <- function() {
    if (!file.exists(GUESSES_FILE)) {
        write.csv(
            data.frame(timestamp = character(), guess = numeric()),
            GUESSES_FILE, row.names = FALSE
        )
    }
}

read_guesses <- function() {
    ensure_file()
    df <- tryCatch(
        read.csv(GUESSES_FILE, stringsAsFactors = FALSE),
        error = function(e) data.frame(timestamp = character(), guess = numeric())
    )
    df$guess <- suppressWarnings(as.numeric(df$guess))
    df[!is.na(df$guess), , drop = FALSE]
}

append_guess <- function(g) {
    ensure_file()
    new_row <- data.frame(
        timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
        guess     = g
    )
    write.table(
        new_row, GUESSES_FILE, append = TRUE, sep = ",",
        row.names = FALSE, col.names = FALSE
    )
}

reset_all <- function() {
    if (file.exists(GUESSES_FILE)) file.remove(GUESSES_FILE)
    ensure_file()
}

format_n <- function(x) format(round(x), big.mark = ",")

# ---- UI ------------------------------------------------------------------

ui <- page_fluid(
    theme = bs_theme(
        version    = 5,
        bootswatch = "minty",
        primary    = "#B5179E",
        base_font  = font_google("Inter")
    ),
    title = "🎤 Wisdom of Crowds — Aggregation Game",

    tags$head(tags$style(HTML("
        .big-stat   { font-size: 2.4rem; font-weight: 700; line-height: 1; }
        .stat-label { font-size: 0.85rem; color: #6c757d; text-transform: uppercase; letter-spacing: 0.05em; }
        .question   { font-size: 1.5rem; font-weight: 600; line-height: 1.35; }
        .truth      { background: #fff3cd; border-left: 6px solid #ffc107; padding: 1rem 1.25rem; border-radius: 0.5rem; }
        .winner     { background: #d1e7dd; border-left: 6px solid #198754; padding: 1rem 1.25rem; border-radius: 0.5rem; }
    "))),

    div(
        class = "container py-4",

        # ---- Header --------------------------------------------------
        div(
            class = "text-center mb-4",
            h1("🎤 The Wisdom of Crowds", class = "display-5 fw-bold"),
            p(class = "lead",
              "Individually, no one knows the answer. Together — the average is shockingly close. ✨")
        ),

        # ---- Question + Submit + Stats -------------------------------
        layout_columns(
            col_widths = c(5, 7),
            gap = "1.5rem",

            # Left: question + input
            card(
                card_header("🤔 Your guess"),
                card_body(
                    div(class = "question mb-3",
                        "How many people attended the last Taylor Swift",
                        tags$em(EVENT_NAME), "concert?"
                    ),
                    p(class = "text-muted small",
                      "🚨 No Google. No neighbor. No AI. Just your gut. 👀"),
                    numericInput(
                        "guess", label = NULL,
                        value = NA, min = 0, max = 1e7,
                        step = 1000, width = "100%"
                    ),
                    actionButton(
                        "submit", "Submit my guess 🎯",
                        class = "btn btn-primary btn-lg w-100",
                        disabled = FALSE
                    ),
                    uiOutput("submit_msg")
                )
            ),

            # Right: live stats
            card(
                card_header("📊 The crowd, so far"),
                card_body(
                    layout_columns(
                        col_widths = c(4, 4, 4),
                        div(class = "text-center",
                            div(class = "stat-label", "Guesses"),
                            div(class = "big-stat text-primary",
                                textOutput("n_guesses", inline = TRUE))
                        ),
                        div(class = "text-center",
                            div(class = "stat-label", "Mean"),
                            div(class = "big-stat text-primary",
                                textOutput("mean_guess", inline = TRUE))
                        ),
                        div(class = "text-center",
                            div(class = "stat-label", "Median"),
                            div(class = "big-stat text-primary",
                                textOutput("median_guess", inline = TRUE))
                        )
                    ),
                    hr(),
                    plotOutput("histogram", height = "240px")
                )
            )
        ),

        # ---- Truth + admin controls ---------------------------------
        br(),
        uiOutput("truth_box"),
        br(),
        uiOutput("admin_controls"),

        # ---- Footer --------------------------------------------------
        hr(),
        div(class = "text-center text-muted small",
            "FAU Summer Institute in Biostatistics & Data Science · ",
            "© 2026 Catalina Cañizares, Ph.D."
        )
    )
)

# ---- Server --------------------------------------------------------------

server <- function(input, output, session) {

    # Track admin mode from URL: ?admin=true
    is_admin <- reactive({
        q <- parseQueryString(session$clientData$url_search)
        isTRUE(tolower(q[["admin"]] %||% "") == "true")
    })

    # Track whether the truth has been revealed
    revealed <- reactiveVal(FALSE)

    # Reactive reader — re-reads the CSV every 1.5s so all clients stay in sync
    guesses <- reactiveFileReader(
        intervalMillis = 1500,
        session        = session,
        filePath       = GUESSES_FILE,
        readFunc       = function(path) read_guesses()
    )

    # ---- Handle submission -----------------------------------------------
    has_submitted <- reactiveVal(FALSE)

    observeEvent(input$submit, {
        g <- input$guess
        if (is.null(g) || is.na(g) || g < 0) {
            showNotification("⚠️ Enter a positive number first.", type = "warning")
            return(invisible())
        }
        if (has_submitted()) {
            showNotification("You've already submitted in this session. 🙈", type = "message")
            return(invisible())
        }
        append_guess(g)
        has_submitted(TRUE)
        showNotification("Guess submitted! 🎉", type = "default", duration = 3)
    })

    output$submit_msg <- renderUI({
        if (has_submitted()) {
            div(class = "alert alert-success mt-3 mb-0",
                "✅ Thanks! Watch the crowd's mean update on the right.")
        }
    })

    # ---- Live stats ------------------------------------------------------
    output$n_guesses <- renderText({
        nrow(guesses())
    })

    output$mean_guess <- renderText({
        df <- guesses()
        if (nrow(df) == 0) return("—")
        format_n(mean(df$guess))
    })

    output$median_guess <- renderText({
        df <- guesses()
        if (nrow(df) == 0) return("—")
        format_n(median(df$guess))
    })

    # ---- Histogram -------------------------------------------------------
    output$histogram <- renderPlot({
        df <- guesses()
        validate(need(nrow(df) > 0, "Waiting for the first guess… 👀"))

        p <- ggplot(df, aes(x = guess)) +
            geom_histogram(
                fill = "#B5179E", color = "white",
                bins = max(8, min(20, round(sqrt(nrow(df)) * 2)))
            ) +
            geom_vline(xintercept = mean(df$guess),
                       linewidth = 1.3, color = "#1f2937") +
            annotate("text", x = mean(df$guess), y = Inf,
                     label = paste0("  mean = ", format_n(mean(df$guess))),
                     hjust = 0, vjust = 1.5, fontface = "bold", size = 4.2,
                     color = "#1f2937") +
            scale_x_continuous(labels = scales::label_comma()) +
            labs(x = "Guess", y = NULL) +
            theme_minimal(base_size = 13) +
            theme(
                panel.grid.minor = element_blank(),
                axis.text.y      = element_blank(),
                plot.margin      = margin(5, 15, 5, 5)
            )

        if (revealed()) {
            p <- p +
                geom_vline(xintercept = TRUE_ATTENDANCE,
                           linewidth = 1.3, color = "#198754",
                           linetype = "dashed") +
                annotate("text", x = TRUE_ATTENDANCE, y = Inf,
                         label = paste0("  truth = ", format_n(TRUE_ATTENDANCE)),
                         hjust = 0, vjust = 3.2, fontface = "bold", size = 4.2,
                         color = "#198754")
        }
        p
    })

    # ---- Truth box -------------------------------------------------------
    output$truth_box <- renderUI({
        if (!revealed()) return(NULL)
        df <- guesses()
        if (nrow(df) == 0) return(NULL)

        crowd_mean <- mean(df$guess)
        err_mean   <- abs(crowd_mean - TRUE_ATTENDANCE)
        err_pct    <- 100 * err_mean / TRUE_ATTENDANCE

        ind_errs   <- abs(df$guess - TRUE_ATTENDANCE)
        n_better   <- sum(ind_errs < err_mean)
        n_total    <- length(ind_errs)

        div(
            class = "winner",
            h4("🎉 The reveal"),
            tags$p(
                "True attendance: ",
                tags$strong(format_n(TRUE_ATTENDANCE)),
                " · Crowd mean: ",
                tags$strong(format_n(crowd_mean)),
                " · Off by ",
                tags$strong(format_n(err_mean), " (", round(err_pct, 1), "%)"),
                "."
            ),
            tags$p(
                "Out of ", tags$strong(n_total), " guesses, only ",
                tags$strong(n_better),
                " individual guess(es) beat the crowd's mean. ",
                tags$em("That's the wisdom of crowds. 🧠")
            ),
            tags$p(class = "small text-muted mb-0",
                   "Now imagine each ", tags$em("guess"), " is a decision tree, ",
                   "and the crowd's mean is a Random Forest. 🌲🌲🌲")
        )
    })

    # ---- Admin controls --------------------------------------------------
    output$admin_controls <- renderUI({
        if (!is_admin()) return(NULL)
        card(
            card_header(class = "bg-warning text-dark", "👩‍🏫 Instructor controls"),
            card_body(
                p("Append ", tags$code("?admin=true"), " to the URL to access these."),
                layout_columns(
                    col_widths = c(6, 6),
                    actionButton(
                        "reveal", "Reveal the truth 🎯",
                        class = "btn btn-success btn-lg w-100"
                    ),
                    actionButton(
                        "reset", "Reset all guesses ♻️",
                        class = "btn btn-outline-danger btn-lg w-100"
                    )
                )
            )
        )
    })

    observeEvent(input$reveal, { revealed(TRUE) })

    observeEvent(input$reset, {
        showModal(modalDialog(
            title = "Reset all guesses?",
            "This deletes every guess so far. Are you sure?",
            footer = tagList(
                modalButton("Cancel"),
                actionButton("confirm_reset", "Yes, reset", class = "btn-danger")
            )
        ))
    })

    observeEvent(input$confirm_reset, {
        reset_all()
        revealed(FALSE)
        has_submitted(FALSE)
        removeModal()
        showNotification("All guesses cleared. 🧹", type = "message")
    })
}

# ---- Run -----------------------------------------------------------------

`%||%` <- function(a, b) if (is.null(a)) b else a

shinyApp(ui, server)
