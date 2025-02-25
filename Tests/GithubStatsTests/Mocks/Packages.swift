//
//  Packages.swift
//  GithubStats
//
//  Created by Streaming on 2025-02-25.
//

let packageV1 = """
{
   "object": {
      "pins": [
         {
            "package":"swift-nio",
            "repositoryURL":"https://github.com/apple/swift-nio.git",
            "state":{
               "branch":null,
               "revision":"ad3c2f1b726549f5d2cd73350d96c3cfc4123075",
               "version":"2.32.0"
            }
         },
         {
            "package":"swift-algorithms",
            "repositoryURL":"https://github.com/apple/swift-algorithms.git",
            "state":{
               "branch":"main",
               "revision":"64ad02f8f5a9c2bd98f2ad6c389e6e86bc2d5b47",
               "version":null
            }
         },
         {
            "package":"swift-collections",
            "repositoryURL":"https://github.com/apple/swift-collections.git",
            "state":{
               "branch":null,
               "revision":"81d1e46256483b2f23b61eb1a588ff5c8d37e9b9",
               "version":null
            }
         }
      ]
   },
   "version":1
}
"""

let packageV2 = """
{
  "pins": [
    {
      "identity": "swift-nio",
      "location": "https://github.com/apple/swift-nio.git",
      "state": {
        "branch": null,
        "revision": "ad3c2f1b726549f5d2cd73350d96c3cfc4123075",
        "version": "2.32.0"
      }
    },
    {
      "identity": "swift-algorithms",
      "location": "https://github.com/apple/swift-algorithms.git",
      "state": {
        "branch": "main",
        "revision": "64ad02f8f5a9c2bd98f2ad6c389e6e86bc2d5b47",
        "version": null
      }
    },
    {
      "identity": "swift-collections",
      "location": "https://github.com/apple/swift-collections.git",
      "state": {
        "branch": null,
        "revision": "81d1e46256483b2f23b61eb1a588ff5c8d37e9b9",
        "version": null
      }
    }
  ],
  "version": 2
}
"""

let packageWithGitlab = """
{
  "pins": [
    {
      "identity": "swift-nio",
      "location": "https://github.com/apple/swift-nio.git",
      "state": {
        "branch": null,
        "revision": "ad3c2f1b726549f5d2cd73350d96c3cfc4123075",
        "version": "2.32.0"
      }
    },
    {
      "identity": "swift-algorithms",
      "location": "https://github.com/apple/swift-algorithms.git",
      "state": {
        "branch": "main",
        "revision": "64ad02f8f5a9c2bd98f2ad6c389e6e86bc2d5b47",
        "version": null
      }
    },
    {
      "identity": "swift-collections",
      "location": "https://github.com/apple/swift-collections.git",
      "state": {
        "branch": null,
        "revision": "81d1e46256483b2f23b61eb1a588ff5c8d37e9b9",
        "version": null
      }
    },
    {
      "identity": "gitlabRepo",
      "location": "https://gitlab.com/example/example.git",
      "state": {
        "branch": null,
        "revision": "some-revision",
        "version": "2.32.0"
      }
    },
  ],
  "version": 2
}
"""

let packageV3 = """
{
  "originHash" : "b7f237e1223a38f5c4a5a88350a8bdc8477ec41596fda2f160212e64885542c0",
  "pins" : [
    {
      "identity" : "swift-argument-parser",
      "kind" : "remoteSourceControl",
      "location" : "https://github.com/apple/swift-argument-parser.git",
      "state" : {
        "revision" : "41982a3656a71c768319979febd796c6fd111d5c",
        "version" : "1.5.0"
      }
    },
    {
      "identity" : "swift-atomics",
      "kind" : "remoteSourceControl",
      "location" : "https://github.com/apple/swift-atomics.git",
      "state" : {
        "revision" : "cd142fd2f64be2100422d658e7411e39489da985",
        "version" : "1.2.0"
      }
    },
    {
      "identity" : "swift-cmark",
      "kind" : "remoteSourceControl",
      "location" : "https://github.com/swiftlang/swift-cmark.git",
      "state" : {
        "branch" : "gfm",
        "revision" : "b022b08312decdc46585e0b3440d97f6f22ef703"
      }
    }
  ],
  "version" : 3
}
"""
