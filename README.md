# CS50Pong


This is from the pong problem set, assignment 0, in CS50 Introduction to Game Develoment course :
https://www.edx.org/course/cs50s-introduction-to-game-development

Main goal: Completed

* Implement an AI-controlled paddle (either the left or the right will do) such that it will try to deflect the ball at all times. Since the paddle can move on only one axis (the Y axis), you will need to determine how to keep the paddle moving in relation to the ball. Currently, each paddle has its own chunk of code where input is detected by the keyboard; this feels like an excellent place to put the code we need! Once either the left or right paddle (or both, if desired) try to deflect the paddle on their own, you’ve done it!

Secondary goal: Completed
* When creating the AI set it up so that it predicts where the ball will pass by and tries to move the paddle there before the ball passes. Limit the AI to only be able to move the paddle as fast as the player is allowed to.

Problem: Completed
* When the ball gets to a certain speed it can pass over the paddle in a single frame resulting in no collision being detected. I fixed this by going through all the balls possible locations since the last frame and then checking for collisions with all of those positions.

check out https://github.com/Kriptikz/CS50Pong/projects/1 to see what's currently going on with this project. Currently Finished.
