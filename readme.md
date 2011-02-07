# What Gem

This is a project designed to help everyone in the Ruby community asses and find new gems.
Every developer works with many different gems everyday. In my daily work, my gemfile
contains ~50 different gems. That's a staggering number of different libraries to use.
Rubyists have a plethora of choices when it comes to deciding what gem is right for a
specific task. The question is, how the hell do you decide which one is better? 
You may consider what everyone else is using, or you may require your gems to have
plenty of tests. You may look for things like, how is the documentation, or how 
can I get in contact with the author? There are many metrics you can use to decide
which one is the best. Whatgem will do all that for you. It will also help you
find new gems.

## Ranking Gems

A Gem is given a score. The maximum possible is 100%. Gems are ranked according
to these factors. The are weighted differently. They are listed in order.

  1. Unit tests present? -- 30%
  2. Online Documentation available? -- 20%
  3. Readme present? -- 10%
  4. Cucumber features present? -- 10%
  5. Examples present? -- 5%
  6. License present? -- 5%
  7. Closed issue percentage -- 5%
  8. Merged pull request percentage -- 5%
  9. Upvote percentage (a-la Reddit) -- 10%

These metrics come from my general evalution criteria. The Ruby community has a very 
important testing bent. If you don't have unit tests, you're going to get docked **hard** for that.
The other metrics are general and come from my and my friends criteria when we are choosing 
new gems (or any library for that matter.) Some of the others comes came from this handly 
time article on the [Changelog](http://thechangelog.com/post/3032074343/top-ten-reasons-why-i-wont-use-your-open-source-project).

These different metrics factor into the a gems over all score. The information
is pulled in from the RubyGems.org and Github API. The gem stats are updated 
continually in the background. **Cucumber** is the currently the #1 gem according to these metrics at ~93%.

There is second set of criteria that count for extra credit. These are more community focused. 
The more community around a gem, the more extra credit it can get. The general idea here is that
each entry will add 0.01% or some other number to total ranking. These extra metrics are in place
to help gems that are lagging in the other metrics to gain points. For example, if a gem does not have
any bundled examples, the community can add more links to make up for the missing content. These metrics 
are have not been implemented yet, and are still under consideration.

  1. Author(s) have twitter feeds?
  2. Gem has mailing list?
  3. Gem has IRC-chan
  4. Gem has been mentioned at conferences?
  5. Gem has screen casts?
  6. Gem has rubygem-testers.org entry 
  7. Author Reputation? (This may be removed because it can be subjective.)
  8. Comments -- More comments the better. 
  9. User posted links/resources. Gems with more resources are better than others.


## Current Features

  * Signin with github oauth to import your gems from your repos.
  * Automatically import gem dependencies as well using Rubygems.org API
  * Comment on Gems
  * Vote up/down gems
  * Tag gems using a prefined set (for grouping gems)

## Planned Features (not in any order)

  * Import gems from a Gemfile
  * View gems from a specific category
  * View gems by a specific author
  * Search gems
  * Ability to update all the extra credit metrics described above

## Project Goals

Here are the project goals in no specific order:

  * Provide the Ruby community with an accurate and fair way of ranking and assesing gems.
  * Provide a way for **new** gems to come onto the scene.
  * Integrate with Ruby Gem Testers so discerning users can see test coverage for their favorite gems
  * Integrate with RubyGems.org to provide a complete and useful gem index.

## Getting Involved

This project is currently run by me (Adman65) and my friend Jon Soeder (Datapimp). 
You can contact me on twitter @Adman65 or Jon @datapimp if you'd like to be involved in the project. 
You can also contact Adman65 on Freenode. He hangs out in #rubyonrails and #railsbridge.
If you are interested in working on the project please let us know. Also, **We are currently very 
interested to hear what you think of the metrics!** All input is welcome. If you think these metrics
are a total ROFL FAIL, tight, let me know why. If you think these metrics are awesome, le me know why!
All input is welcome.

## Open Source Goodness

The wbsite is backed by Rails 3. We are using Resque for background processing. We are using the
execellent cucumber library for integration testing and rspec for unit tests. We strive for clean code
and well tested code. **We are open to forks and pull requests.** You can make features. Granted, they 
may not be accepted, but we want to see what you want to do and how this site can help you.
**This is a community effort.**
