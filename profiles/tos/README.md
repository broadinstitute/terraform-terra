TODOS:

- Had to enable cloudfunctions api in qa project, apparently because that's where the SA came from. Why?
- Did not yet grant access to perf datastore because I wasn't sure about namespacing requirements
- Deploy steps are set to always run, limit to when refspec changes by removing `always` trigger
