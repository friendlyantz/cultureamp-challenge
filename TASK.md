# Culture Amp Technical Interview Exercise

In this exercise, we look forward to working with you and learning about how you approach
hands-on technical work.

We’re sharing this exercise in advance so you can familiarise yourself with it as much (or
as little) as you need. You don’t need to do any other work ahead of time - there’ll be
enough time in the interview for us to work through everything together.

## How we’ll spend our time together

This part of your interview will consist of the following:

**1. Requirements discussion and domain modelling (~20 minutes)**

We’ll start by confirming your understanding of the [requirements](#requirements), and
then you’ll model a possible solution at a high-level. We’ll discuss this with you as you
go.

What may be useful here is to draw a diagram representing the various parts of your
solution and how they’ll interact.

**2. Coding (~30 minutes)**

We’ll work with you as if part of a pair or mob coding session to build the beginnings of
the requirements detailed below.

We don’t expect you to implement the requirements in full! We’re interested primarily in
seeing how you go about working with code in general. We encourage you to spend this time
working on the most _interesting_ parts of the solution, rather than trying to build
something fully working end to end.

**3. Wrap up (~10 minutes)**

We’ll have a chat about how we went, and discuss how this application may need to evolve
in the future.

## What we’re looking for

While we work with you, we’ll be interested in learning about the following traits, which
we believe are important for engineers at Culture Amp:

- **Collaboration**
  - Responding to feedback
  - Working out loud
- **Technical Communication**
  - Ability to explain a technical idea clearly
- **Problem Solving**
  - Identifying scope
  - Design and modelling skills
- **Quality code**
  - Attention to detail in satisfying requirements
  - Use of well-factored code
  - Attention to maintainability
  - Use of tests
  - Empathy with future engineers
- **Effective use of tech stack**
  - Proficiency with chosen programming language
  - Understanding of best practices
  - Approach to picking and justifying use of libraries/frameworks
- **Product thinking**
  - Empathy with the user
  - Understanding of business goals

## What we’ll be building
<a name="requirements"></a>

Your task is to build a CLI application to parse and analyse survey data from CSV files
and display some results.

The application should accept two arguments:

1. A data file name
2. An analysis mode

It should parse the file and present the results of the specified analysis.

The analysis modes should include:

1. Participation: the number and percentage of submitted responses for the survey
2. Average results: the average result for each question
3. Answer frequency: the frequency of answers for each question displayed as a histogram

Any response with a submission time is considered to have participated in the survey.
Results from non-submitted surveys should not be considered in the analysis.

*As mentioned above, we don’t expect you to implement these in full, but we’d at least
like to see an application structure that can gracefully support these in the future.*

#### Data Format

See `example-data/survey.csv` for an example survey file.

Each row represents a response to the survey.

The headers in the file are:

- Email
- Employee ID
- Submitted time (if there is no submitted at timestamp, you can assume this person did
  not submit a survey)
- A column for the answer to each survey question. The headers contain the question text.

    Answers to questions are always an integer between (and including) 1 and 5. Blank
    values represent not answered questions.

## Getting started

In the `src/` directory, there are starter kits for Culture Amp's various key
tech stacks. Each will have their own README detailing how to get started.

Please pick a tech stack that’s familiar to you and will show you at your best.

You can also choose to use a different tech stack altogether, but please make sure that
your setup is ready to go by the time of the interview.
