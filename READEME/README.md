# US Road Accidents Data Analysis Project


🌟 For detailed insights and conclusion see the full [Project Presentation](https://drive.google.com/file/d/1iqcE8c0RwmU5KiP97YJEceNtrH35SI7v/view?usp=sharing).

This comprehensive data analytics project analyzes US road accident patterns to identify key safety insights and risk factors. By leveraging a complete Microsoft BI stack, we transform raw accident data into actionable intelligence for traffic safety decision-making.

  

## Business Objectives (What we wanted to achieve)

- Identify patterns and key contributing factors behind traffic accidents.
- Detect high-risk states, times, and driver groups.
- Measure the impact of weather, speed, and road conditions on accident severity.
- Evaluate emergency response effectiveness across different regions
- Enable safer speed limits decisions, better emergency response planning, and targeted awareness campaigns.

 

## Technical Architecture

This project demonstrates a complete data pipeline using Microsoft's Business Intelligence stack. Each component folder contains detailed implementation guides and documentation:


- **[Database](./Database)** - Normalized relational database design Microsoft SQL Server

- **[Data Warehouse](./DataWarehouse)** - Star schema implementation with dimensional modeling

- **[ETL Process](./SSISpipeline)** - SSIS packages for data extraction, transformation, and loading

- **[Reporting & Analytics](./SSRS/US_Accident_SSRS)** SSRS reports for structured data presentation & SSAS cubes for multidimensional analysis

- **[Visualization](./Dashboards)** - Interactive Power BI & Tableau dashboards for data exploration

## Key Insights (Highlights)
- Mondays and midday hours show the highest accident frequency.  
- Nearly half of accidents involve young drivers, with trucks as the top vehicle type.  
- Speeding-related accidents peak in the afternoon and evening.  
 

## Dataset

The dataset covers all 50 U.S. states over the period January 1, 2024 – February 29, 2024. It includes details on:

- Environmental conditions (weather, light, visibility, road surface).
- Road and Geographic information (junction type, speed limits, road width, state).
- Vehicle and driver information (vehicle type, driver age group).
- Accident impact (number of vehicles involved, casualties, emergency response).
- Emergency response metrics.
