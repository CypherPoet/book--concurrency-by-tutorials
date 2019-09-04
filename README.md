# Concurrency by Tutorials

_Projects, playgrounds, and other materials made while following along with the Ray Wenderlich book ["Concurrency by Tutorials"](https://store.raywenderlich.com/products/concurrency-by-tutorials)_.


# Contents

- [Chapter 3: Queues & Threads](./03-queues-and-threads)
  - How to use a GCD queue to offload work from the main thread.
  - What _is_ a thread? And, perhaps more importantly, how do we operate with them in the context of Apple platforms?


- [Chapter 4: Groups & Semaphores](./04-groups-and-semaphores)
  - How to submit multiple tasks to a queue, which need to run together as a "group" so that we can be notified when they have all completed.
  - Wrapping an existing API so that it can be called asynchronously.


- [Chapter 5: Concurrency Problems](./05-concurrency-problems)
  - Some of the common pitfalls encountered while executing concurrent tasks.


- [Chapter 6: Operations](06-operations)
  - Utilizing the `Operation` class to gain more powerful control over concurrent tasks.


- [Chapter 7: Operation Queues](07-operation-queues)
  - Similar to Dispatch Queues, but for `Operation` instances.


- [Chapter 8: Asynchronous Operations](08-asynchronous-operations)
  - Making operations themselves asynchronous now that we can submit them to Operation Queues.


- [Chapter 9: Operation Dependencies](09-operation-dependencies)
  - The "killer feature" of `Operation`s is being able to tell the OS that one operation is dependant on another and shouldn't being until the dependency has finished.

- [Chapter 10: Cancelling Operations](10-cancelling-operations)
  - Cancelling operations when they're running &mdash; or before they've even started.
