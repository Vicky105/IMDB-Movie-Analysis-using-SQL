# IMDB-Movie-Analysis-using-SQL

## Table of Contents
* [Introduction](#introduction)
* [Data Sources](#data-sources)
* [Data Dictionary](#data-dictionary)
* [Methodology](#methodology)
* [Key Findings](#key-findings)
* [Tools Used](#tools-used)
* [Conclusion](#conclusion)
* [Future Work](#future-work)

## Introduction
This project involves an in-depth analysis of movies and directors from the IMDb dataset. The analysis focuses on various aspects of movies, including their budgets, revenues, ratings, and more, as well as on directors, their gender, and their impact on movie success.

## Data Sources
IMDB Movies dataset:
1. For Movies Dataset <a href="https://github.com/Vicky105/IMDB-Movie-Analysis-using-SQL/blob/721581ec380790763821dcbaa44243f3cba52d26/MOVIES_DATASET.csv">Click Here</a>
2. For Directors Dataset< a href="https://github.com/Vicky105/IMDB-Movie-Analysis-using-SQL/blob/721581ec380790763821dcbaa44243f3cba52d26/DIRECTORS.csv">Click Here</a>

## Data Dictionary

### Movies Table
| Column Name    | Description                      | Data Type |
|----------------|----------------------------------|-----------|
| id             | Unique identifier for the movie  | INT       |
| original_title | Original title of the movie      | VARCHAR   |
| budget         | Budget of the movie              | INT       |
| popularity     | Popularity score                 | INT       |
| release_date   | Release date                     | DATE      |
| revenue        | Revenue generated                | FLOAT     |
| title          | Title of the movie               | VARCHAR   |
| vote_average   | Average rating                   | FLOAT     |
| vote_count     | Number of votes                  | INT       |
| overview       | Brief description                | VARCHAR   |
| tagline        | Tagline of the movie             | VARCHAR   |
| uid            | Unique identifier                | INT       |
| director_id    | Unique identifier for the director | INT     |

### Directors Table
| Column Name | Description            | Data Type |
|-------------|------------------------|-----------|
| name        | Name of the director   | VARCHAR   |
| id          | Unique identifier      | INT       |
| gender      | Gender of the director | INT       |
| uid         | Unique identifier      | INT       |

## Methodology
**Data Cleaning and Preprocessing:**
- Removed any unnecessary or redundant columns.
- Cleaned and formatted textual data, such as movie titles and director names.
- Changed data types of some columns for aggregation purposes.

**Data Analysis:**
- **Trends in Movie Releases:** Analyzed the distribution of movie releases over time.
- **Budget and Revenue Analysis:** Compared movie budgets with their revenues to understand profitability.
- **Rating and Popularity Correlation:** Investigated the relationship between movie ratings and popularity.
- **Genre Analysis:** Created genres for movies using keywords and conducted further analysis on aspects like average revenue and average rating for each genre.
- **Director Analysis:** Analyzed the impact of director gender and other factors on movie success.

## Key Findings
- **Budget vs. Revenue:** Analysis revealed a correlation between movie budgets and revenues, indicating that higher budgets often lead to higher revenues.
- **Time Series Analysis on Movie Count:** Analysis of the number of movies released over time showed significant trends and variations across different periods.
- **Impact of Genre on Movie Success:** Certain genres tend to have higher average ratings and revenues, indicating a potential correlation between genre and movie success.

## Tools Used
- **Excel**: For preprocessing of data.
- **SQL**: For data cleaning and analysis.

## Conclusion
This project provides comprehensive insights into various aspects of movies and directors. It reveals trends in movie production, financial success factors, and the influence of directors on movie outcomes. These insights can help industry professionals, including producers and analysts, make data-driven decisions.

## Future Work
- **Genre-Specific Analysis:** Deeper analysis of specific genres and their characteristics.
- **Visualization:** Develop interactive dashboards using Power BI to present findings in a more accessible format.
