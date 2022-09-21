
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ShinyFriendlyCaptcha

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/ShinyFriendlyCaptcha)](https://CRAN.R-project.org/package=ShinyFriendlyCaptcha)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R
badge](https://img.shields.io/badge/Build%20with-♥%20and%20R-blue)](https://github.com/mhanf/ShinyFriendlyCaptcha)

<!-- badges: end -->

The goal of ShinyFriendlyCaptcha is to provide [Friendly
Captcha](https://friendlycaptcha.com/) to Shiny apps.

## Features

Friendly Captcha is an European alternative to Google Recaptcha. It
allow to protect websites against spam and bots in a privacy-embedded
design.

Main features :

-   Cryptographic bot protection
-   No labeling tasks for users
-   No tracking and cookies
-   Fully accessible
-   Guaranteed availability with SLA
-   GDPR compliance agreements

## Installation

You can install the development version of ShinyFriendlyCaptcha from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mhanf/ShinyFriendlyCaptcha")
```

## Example

In order to use the ShinyFriendlyCaptcha library, you’ll need to go to
the Friendly Captcha [websitete](https://friendlycaptcha.com/) and
subscribe a plan to generate valid `SITEKEY` and `SECRET` strings.

A free plan is proposed to developers for non-commercial use (protection
of 1 website with up to 1,000 requests/month). For more details go to
their [website](https://friendlycaptcha.com/).

ShinyFriendlyCaptcha exports two main functions: `sfc_output()` and
`sfc_server()`.

A vignette is available [here]() to help in the proper setup of these
functions.

A Shiny app example using these functions can be created as follows:

**work in progress**

## Contributions

The developer and maintainer is [mhanf](https://github.com/mhanf).
External contributions are welcome. Please keep in mind that I am not a
professional R developer but an enthusiastic R data scientist who plays
with shiny and javascript as a pretext to learn new stuffs.
Unfortunately, so is my code. Please note that the ShinyRating project
is released with a [Contributor Code of
Conduct](https://mhanf.github.io/ShinyRating/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.

## License

The ShinyFriendlyCaptcha package as a whole is licensed under the
[MIT](https://opensource.org/licenses/mit-license.php) license.