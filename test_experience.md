## Test Experience

The best(?) and tedious method to test is to follow BDD.

Integration Failure => Unit Test Failure => Unit Test Success => Unit Test Refactor =>
Do Unit Test Cycle again => Integration Success => Integration Refactor => Do Integration Cycle again
ref: ![BDD](https://i.stack.imgur.com/mtLAM.png | width=248)

But the actual use case is that If we lose the **CORRECT** working code, then any unit test is redundant in my opinion.

At least the code should ever work on the happy path, then we narrow the design of code, yes, unit test.

So the cycle I used is, Integration Cycle with happy path, Unit Cycle to narrow design, run both tests.

According to the [acceptance criteria](https://en.wikipedia.org/wiki/User_story#Acceptance_criteria), we should make other unhappy paths with the above cycle.

Furthermore, I won't follow the cycle above If the class is self-contained, or just the class that used third-party package. You could still follow the cycle, but normally I will just do integration test to valid the usage of package and use mockito to mock It If any dependency occurs in unit test.

## Based on project

So did I really recommended integration cycle, then unit test? Nope, It's based on project. Let's give an example of normal business app. The app normally won't have too many third-party dependency, just restful/graphql with the server, so you could simply **MOCK** the object with any fake edge datas. But for the project like this, interact with cli, use third-party application, check exsited file...etc. All the stuffs like these **should not** use unit test, since you should realize how third-party works, so there is no possible to realize It on unit-test, just go integration test, and no need any unit test or less is enough.
