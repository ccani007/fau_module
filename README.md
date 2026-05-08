# 🌴 FAU Summer Module — Data Science & Machine Learning with R

> **Florida Summer Institute in Biostatistics and Data Science (FSIBDS)**
> A hands-on module for early-career students who want to learn how to *think*, *code*, and *model* like a data scientist — using R, Quarto, and `tidymodels`. 🚀

---

## 👋 Welcome!

Hi! I'm **Catalina Cañizares, Ph.D.** 👩🏻‍🏫
I'm a researcher and educator who loves teaching people how to use data to ask better questions about human behavior and health. In this module, you'll learn the core tools of modern data science in R,  from your very first `mutate()` to training and tuning machine learning models with `tidymodels`. ✨


**Prerequisites:** none! 💪 If you can open a laptop, you can do this. We will go *as fast as the slowest person in the room*.

---

## 🎯 What you'll learn

By the end of the **4-day module**, you will be able to:

- ✅ Build a reproducible **Quarto website** for your project
- ✅ Wrangle and clean real-world data with the **`tidyverse`**
- ✅ Understand the core ideas of **machine learning** (training, testing, resampling, tuning)
- ✅ Fit and evaluate **regularized regression** (Ridge, Lasso, Elastic Net)
- ✅ Train **tree-based models**: Decision Trees, Random Forest, XGBoost
- ✅ Apply **K-Nearest Neighbors** (KNN)
- ✅ Use the **`tidymodels`** ecosystem end-to-end on real public-health data
- ✅ **Publish your project online** — a real, sharable URL you can put on your CV 🌐

---

## 🌟 The deliverable: your own ML project website

By Thursday, each of you will publish a **Quarto website** like this one:
👉 **[Example student project](https://ccani007.github.io/machine-learning-project-FAU/)**

It contains:

- 🙋 An *About me* page
- 🧪 A *Dataset & research question* page
- 🤖 One page per ML model you fit (Lasso, Decision Tree, Random Forest, KNN…)

You'll get a public URL on **Quarto Pub** that you can share with your family, your PI, or your future grad-school applications. 💼

---

## 🗓️ Module schedule & materials

> **4 sessions, Monday → Thursday.** All slides are written in **Quarto** (`.qmd`) and published to Quarto Pub. Click the **🌐 Slides** link to view, or open the `.qmd` file in this repo to follow along in RStudio.

### 📘 Day 1 (Mon) — Intro to R, Quarto & your project website
| File | Topic | Slides |
|------|-------|--------|
| [`hello_r_and_quarto.qmd`](hello_r_and_quarto.qmd) | R, RStudio, Quarto, and the **ML project template** you'll publish | [🌐 Slides](https://catalina.quarto.pub/session-1---intro-to-r) |

### 📗 Day 2 (Tue) — Data Wrangling
| File | Topic | Slides |
|------|-------|--------|
| [`hello_tidyverse.qmd`](hello_tidyverse.qmd) | The Data Jedi Academy: cleaning data with `tidyverse` | [🌐 Slides](https://catalina.quarto.pub/session-2---the-data-jedi-academy-cleaning-your-data-with-r-and-tidyverse) |

### 📙 Day 3 (Wed) — Intro to Machine Learning
| File | Topic | Slides |
|------|-------|--------|
| [`hello_ml.qmd`](hello_ml.qmd) | What *is* machine learning? Core vocabulary & intuition | [🌐 Slides](https://catalina.quarto.pub/introduction-to-machine-learning-ec98) |
| [`hello_tidymodels.qmd`](hello_tidymodels.qmd) | The `tidymodels` workflow: split, recipe, model, fit, evaluate | [🌐 Slides](https://catalina.quarto.pub/introduction-to-tidymodels-78fb) |
| [`hello_lasso.qmd`](hello_lasso.qmd) | Ridge, Lasso, and Elastic Net — taming overfitting | [🌐 Slides](https://catalina.quarto.pub/regularization-techniques-ridge-lasso-and-elastic-net-using-tidymodels-daaa) |

### 📕 Day 4 (Thu) — Trees, Forests, Neighbors & 🚀 Publish!
| File | Topic | Slides |
|------|-------|--------|
| [`hello_DecisionTrees.qmd`](hello_DecisionTrees.qmd) | Decision Trees 🌳 | [🌐 Slides](https://catalina.quarto.pub/decision-trees-using-tidymodels-cce4) |
| [`hello_RandomForest-XGboost.qmd`](hello_RandomForest-XGboost.qmd) | Random Forest & XGBoost 🌲🌲🌲 | [🌐 Slides](https://catalina.quarto.pub/random-forest-and-xgboost) |
| [`hello_KNN.qmd`](hello_KNN.qmd) | K-Nearest Neighbors 👯 | [🌐 Slides](https://catalina.quarto.pub/knn-using-tidymodels) |

### ✨ Bonus / *if we have time*
| File | Topic | Slides |
|------|-------|--------|
| [`hello_beautiful_tables.qmd`](hello_beautiful_tables.qmd) | *Shake It Off* — mastering `gt`, `gtsummary`, and `table1` with Taylor Swift's tracks 🎤 | [🌐 Slides](https://catalina.quarto.pub/session-2---shake-it-off-mastering-data-tables-with-taylor-swifts-tracks) |

---

## 🧪 The dataset

Throughout the module we use the **Youth Risk Behavior Survey (YRBS), 2021** — a national survey by the CDC that monitors health-related behaviors among U.S. high school students (substance use, mental health, bullying, physical activity, and more).

📂 You'll find the raw data in [`data/`](data/):
- `yrbs_2021.csv`
- `yrbs_2021.xlsx`
- `yrbs_2021.sav` (SPSS)


---

## 💻 Getting set up

You have **two options** to follow along:

### Option 1 — Posit Cloud (easiest, nothing to install) ☁️
1. Create a free account at [posit.cloud](https://posit.cloud)
2. Open the project link shared in class
3. You're ready to go!

### Option 2 — Install locally
1. Install **R**: <https://cran.r-project.org>
2. Install **RStudio Desktop**: <https://posit.co/download/rstudio-desktop/>
3. Install **Quarto**: <https://quarto.org/docs/get-started/>
4. Open `fau_module.Rproj` in RStudio
5. Install the packages we use:

```r
install.packages(c(
  # Core tidyverse + Quarto
  "tidyverse", "rUM", "rio", "janitor", "skimr",
  # Tables & figures
  "gt", "gtExtras", "gtsummary", "table1", "taylor",
  # Modeling
  "tidymodels", "usemodels", "themis", "vip",
  # Tree-based engines
  "ranger", "xgboost", "rpart", "rpart.plot",
  # Misc
  "palmerpenguins", "devtools"
))

# Pre-cleaned YRBS teaching dataset
devtools::install_github("ccani007/MLearnYRBSS")
```

---

## 📚 Extra materials & recommended reading

Want to keep going after the module ends? Here are my favorites. 💛

### 🆓 Free online books
- **[R for Data Science (2e)](https://r4ds.hadley.wickham.co.nz/)** — Hadley Wickham & Mine Çetinkaya-Rundel. *The* book to learn the tidyverse.
- **[Tidy Modeling with R](https://www.tmwr.org/)** — Max Kuhn & Julia Silge. The official `tidymodels` book.
- **[An Introduction to Statistical Learning (with R)](https://www.statlearning.com/)** — James, Witten, Hastie & Tibshirani. The classic ML textbook (free PDF).
- **[Hands-On Machine Learning with R](https://bradleyboehmke.github.io/HOML/)** — Boehmke & Greenwell.
- **[Feature Engineering and Selection](https://bookdown.org/max/FES/)** — Kuhn & Johnson.
- **[Quarto documentation](https://quarto.org/docs/guide/)** — everything you can do with Quarto.
- **[Happy Git with R](https://happygitwithr.com/)** — Jenny Bryan's gentle intro to Git for R users.

### 🎥 Video & courses
- [Julia Silge's YouTube channel](https://www.youtube.com/@JuliaSilge) — weekly screencasts using `tidymodels` on real data.
- [Posit (RStudio) on YouTube](https://www.youtube.com/@PositPBC)
- [Andrew Ng's *Machine Learning Specialization*](https://www.coursera.org/specializations/machine-learning-introduction) (Coursera, audit free).

### 📄 Cheatsheets
- [Posit cheatsheets](https://posit.co/resources/cheatsheets/) — `dplyr`, `ggplot2`, `tidyr`, `purrr`, `tidymodels`, and more.

### 🧠 Practice your skills
- [TidyTuesday](https://github.com/rfordatascience/tidytuesday) — a new public dataset every week.
- [Kaggle Learn](https://www.kaggle.com/learn) — short, free micro-courses.
- [Riffomonas Project](https://www.riffomonas.org/code_club/) — Pat Schloss's "Code Club" screencasts.

### 💬 Communities to join
- [Posit Community Forum](https://forum.posit.co/)
- [#rstats on Bluesky / Mastodon / X](https://bsky.app/hashtag/rstats)
- [R-Ladies](https://rladies.org/) — global community supporting gender minorities in R.

---

## 🧑🏻‍🏫 About the instructor

**Catalina Cañizares, Ph.D.** is a researcher and educator focused on using data science and machine learning to study mental health and youth risk behavior. She loves R, reproducible research, and making intimidating topics feel approachable.

- 🌐 GitHub: [@ccani007](https://github.com/ccani007)
- 📧 Reach out via the GitHub issues tab if you find a typo or have a question about the materials.

---

## 📜 License

Unless noted otherwise on a specific session, all materials are licensed under
**[Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)](https://creativecommons.org/licenses/by-nc-nd/4.0/)** © 2024–2026 Catalina Cañizares.

You are free to **share** the materials with attribution, for **non-commercial** purposes, **without modification**.

---

> *"The best way to learn data science is to do data science."* — let's go! 🌟
