---------------------------------------------------------------------------------------------
We want to know how do you structure the code and design the API

==========================================

We would like you to implement a "good night" application to let users track when do they go to bed and when do they wake up.

We require some restful APIS to achieve the following:

1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records of a user's All friends from the previous week, which are sorted based on the duration of All friends sleep length.

Please implement the model, db migrations, and JSON API.
You can assume that there are only two fields on the users "id" and "name".

You do not need to implement any user registration API.

You can use any gems you like.
============================

After you finish the project, please send me your GitHub project link.

We want to see all of your development commits.
- It is important to have separate commits with clear descriptions for each change.
- In Tripla, it is not a good practice to have one commit with a lot of changes.

Please ensure that you have granted permission for Google Meet to share your screen, as we may need you to do so during the meeting
---------------------------------------------------------------------------------------------

## Questions

Thanks for the question. I think I have another candidate asked the same question.

Here  is his question to Tripla:

“In the test assignment, I just want to confirm one point.
To clarify, in the given task, you mentioned that there is a clock-in time API available, but there is no mention of a clock-out time API. It is necessary to have a clock-out time API in order to calculate the length of sleep, as mentioned in the third point of the task:

“3. See the sleep records over the past week for their friends, ordered by the length of their sleep.”
Can you give me more details about the clock-out time or I Will Create a clock-out API same as the clock-in?
Thank you.”


Their answer:

“Please let him know as follows:
One of the main goals is to track the duration of sleep (clock-in and clock-out are for obtaining this information).
You are free to design any solution that you believe will achieve this goal effectively.
In the interview, you can explain your design approach and any choices you make, and we will consider all proposals.
Thank you.”
