The app uses TripPlannerCore framework for building routes and loading connections.
So all the logic related to loading data, building routes, filtering to and from places, and tests are encapsulated inside the framework.
The framework only exposes protocols and structs, the entry point to the framework is in Root.swift file, wich contains `start` function.
`start` returns the implementation of `TripPlanner` protocol.
`TripPlanner` allows users to load available connections, choose `from` and `to`, and build the route.
`build` returns an array of `PresentableRoute`, the struct containing everything needed for displaying the route in the app, including the total price, and approximate distance
of the route, this information is available in `metrics`. `PresentableRoute` also contains an array of `RouteTag`, there are two tags so far (`.cheapest`, and `.shortest`).
The algorithm returns two routes (cheapest first, and shortest second) if those routes are different, if routes are equal those two elements are merged into one with two tags
`.cheapest` and `.shortest`.

The framework uses `ShortestRouteBuilder` protocol for building the shortest routes.
There is one implementation of that protocol in the framework: `DijkstrasRouteBuilder`, so because the Dijkstras algorithm is used there is one limitation: it does not support
negative weights. This limitation is reflected in tests.

There is room for improvement, the implementation can be replaced with the Bellman-Ford algorithm, or still use Dijkstra, but choose a different data structure for storage.
According to this topic, https://brilliant.org/wiki/shortest-path-algorithms/ performance can be significantly improved using binary or Fibonacci heap.
The algorithm implementation is generic, but it requires elements to conform to `Hashable`, and weight to conform to `Number` (compare with zero, other numbers, and `max`).

The following graphs are tested:

<img width="481" alt="test_build_findsShortestPath1" src="https://github.com/dzhagazs/TripPlanner/assets/22398516/16d11c34-1b9a-4883-a859-fda37d5432c1">
<img width="478" alt="test_build_findsShortestPath2" src="https://github.com/dzhagazs/TripPlanner/assets/22398516/27a908cf-c94f-421d-a1a8-bdbc6f77a9d1">
<img width="553" alt="test_build_findsShortestPath3" src="https://github.com/dzhagazs/TripPlanner/assets/22398516/a4c4b0d0-5d18-4161-920c-bb0384a7a556">
<img width="434" alt="test_build_findsShortestPath4" src="https://github.com/dzhagazs/TripPlanner/assets/22398516/d9558ae6-ab47-43fa-9219-dce1f08ebea7">
<img width="431" alt="test_build_findsShortestPath5" src="https://github.com/dzhagazs/TripPlanner/assets/22398516/1ae9353e-f875-4052-a4d7-153ed27b4dfb">
<img width="418" alt="test_build_findsShortestPathWithCycle1" src="https://github.com/dzhagazs/TripPlanner/assets/22398516/39149af0-6132-4539-9b67-d3080b9975f1">
<img width="517" alt="test_build_findsShortestPathWithCycle2" src="https://github.com/dzhagazs/TripPlanner/assets/22398516/765c9f81-80f7-4c20-b684-691cd18f2c0d">

