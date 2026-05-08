# 🎤 Wisdom of Crowds — Aggregation Game

A small Shiny app for the FAU Summer Institute module (Day 4 — Random Forest session).
Demonstrates the **Condorcet Jury Theorem** before introducing Random Forest:
no single student knows the answer, but the **mean of the class's guesses** is
shockingly close to the truth. Each guess = one decision tree. The crowd mean = a
Random Forest. 🌲🌲🌲

---

## ✨ What it does

- Students submit a single numeric guess to *"How many people attended the last
  Taylor Swift concert at Acrisure Stadium, Pittsburgh, during the Eras Tour?"*
- Live updating histogram + crowd mean + median + count.
- Instructor button to **reveal the truth** at the end.
- Instructor button to **reset all guesses** between cohorts.

---

## 🗂️ Files

```
aggregation_game/
├── app.R              # the entire Shiny app
├── README.md          # this file
└── .gitignore         # don't commit student guesses
```

The app writes to `guesses.csv` in its own working directory while running.

---

## 🚀 Run it locally (5 seconds)

```r
# install once
install.packages(c("shiny", "bslib", "ggplot2", "dplyr", "scales"))

# run from the project root
shiny::runApp("aggregation_game")
```

---

## ☁️ Deploy to shinyapps.io (free)

```r
# 1. install rsconnect
install.packages("rsconnect")

# 2. configure your account once (token from https://www.shinyapps.io/admin/#/tokens)
rsconnect::setAccountInfo(
    name   = "your-shinyapps-username",
    token  = "...",
    secret = "..."
)

# 3. deploy
rsconnect::deployApp(
    appDir   = "aggregation_game",
    appName  = "wisdom-of-crowds",
    appTitle = "Wisdom of Crowds — FAU"
)
```

The public URL will be:
`https://your-username.shinyapps.io/wisdom-of-crowds/`

Add it to `hello_RandomForest-XGboost_v2.qmd` where the original
HuggingFace URL was.

---

## 👩‍🏫 Instructor mode

Append `?admin=true` to the URL — a new "Instructor controls" panel appears
with two buttons:

- **Reveal the truth 🎯** — overlays the true attendance on the histogram and
  shows a summary of how the crowd's mean compares to individual guesses.
- **Reset all guesses ♻️** — wipes `guesses.csv` so you can reuse the app for
  another cohort. (Confirmation modal appears.)

So:

- Student URL: `https://your-username.shinyapps.io/wisdom-of-crowds/`
- Instructor URL: `https://your-username.shinyapps.io/wisdom-of-crowds/?admin=true`

---

## ⚠️ Storage caveat

shinyapps.io has an **ephemeral filesystem** — `guesses.csv` lives only inside
the running container. While the container is warm (during an active class),
all students share the same file. After ~15 minutes of inactivity the
container sleeps; on next wake the file is gone.

This is **fine for in-class use** — start the class by submitting one guess
yourself to wake the container, and run the activity within ~10 minutes.

If you need persistence across days, swap the CSV functions in `app.R` for
[`googlesheets4`](https://googlesheets4.tidyverse.org/) or any database.

---

## 📝 Customizing for a new question

Edit these constants at the top of `app.R`:

```r
TRUE_ATTENDANCE <- 73117                      # the real answer
EVENT_NAME      <- "Acrisure Stadium, Pittsburgh — Eras Tour, June 2023"
```

And update the question text inside the `card_body()` of the "Your guess"
card. That's it.

---

## 🎯 In-class flow

1. Open the **student URL** on the projector. Project for the class.
2. Tell students: *"No Google. No neighbor. Submit your guess."*
3. Watch the histogram fill up live.
4. Switch to the **instructor URL**, click **Reveal the truth 🎯**.
5. The truth line appears on the histogram, plus a summary of how few
   individual guesses beat the crowd's mean.
6. Bridge to the slides: *"Each guess was a decision tree. The crowd mean is
   a Random Forest. That's why ensembles work."* 🌲🌲🌲

---

## License

© 2026 Catalina Cañizares, Ph.D. · CC BY-NC-ND 4.0
