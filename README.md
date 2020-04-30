`async` tutorial 2020 ([HaskellerZ talk](https://www.meetup.com/HaskellerZ/events/270136648/))
=======================================

_by Niklas Hambüchen_

This provides the files we will start with in the tutorial.

You can clone this repo and then follow along the talk.


# Relevant links

* New async docs (to be part of next `async` release): https://nh2.me/async-docs
* [Pooled concurrency in `unliftio`](http://hackage.haskell.org/package/unliftio-0.2.12.1/docs/UnliftIO-Async.html#g:9)
* Concurrent stream processing: [`conduit-concurrent-map`](https://hackage.haskell.org/package/conduit-concurrent-map)


### Notes during the tutorial

Look at the `live-tutorial` branch to see how the code evolved.

* Tutorial template: https://github.com/nh2/haskellerz-async-tutorial-2020
* remind me to stop when following with code
* make a function that simulates downloading (`getURL`)
* go through https://nh2.me/async-docs
* aborting on failure by default -- silent failure is bad
  * introduce the important `async` properties
  * insert simulated connection failure for `url1`
* show how exceptions get raised on `wait` (switch to fail for `url2`)
* show higher-level functions (resume going through docs)
* exceptions
  * why we have to think about exceptions
  * synchronous and asynchronous, examples (`timeout`)
  * `bracket`
* how the RTS works (N-on-M green threading)
* plain `forkIO`
  * examples of why it is bad
* `unliftio`
* resource considerations
  * semaphore
  * pooled concurrency in `unliftio`: http://hackage.haskell.org/package/unliftio-0.2.12.1/docs/UnliftIO-Async.html#g:9
  * simple example: https://gist.github.com/nh2/1500af99cfe6a8f45848d8c1e92ad9ba
  * streaming processing
  * head-of-line blocking
  * `conduit-concurrent-map`: https://github.com/nh2/conduit-concurrent-map
* Alexey to metion starting overhead

#### Summary of what you should remember

  * How does concurrency work in Haskell?
  * What are the underlying primitives?
  * What does async do?
  * what functions to use in practice?
  * What are common mistakes?
