import XCTest
@testable import Tina

protocol Binable: Sessionable {}

extension Binable {
    static func host() -> String? {
        return "httpbin.org"
    }
    
    static func requestHandlers() -> [RequestHandleable] {
        return []
    }
    
    static func responseHandlers() -> [ResponseHandleable] {
        return []
    }
}

final class TinaTests: XCTestCase {
    func testGetExample() {
        let promise = expectation(description: "Just wait request")
        
        class GetRequest: Getable, Binable {
            var foo: String?
            init(foo: String?) {
                self.foo = foo
            }
            
            var path: String? { "get" }
            
        }
        let gr = GetRequest(foo: "bar")
        gr.get { response in
            promise.fulfill()
            print(response)
        }
        waitForExpectations(timeout: 60) { (error) in
        }
    }

    func testPostExample() {
        let promise = expectation(description: "Just wait request")
        
        class PostRequest: Postable, Binable {
            var path: String? { "post" }
        }
        let pr = PostRequest()
        pr.post { response in
            promise.fulfill()
            print(response)
        }
        waitForExpectations(timeout: 60) { (error) in
        }
    }
    
    func testHeadExample() {
        let promise = expectation(description: "Just wait request")
        
        class PostRequest: Headable, Binable {
            var path: String? { "head" }
        }
        let pr = PostRequest()
        pr.head { response in
            promise.fulfill()
            print(response)
        }
        waitForExpectations(timeout: 60) { (error) in
        }
    }

    
    static var allTests = [
        ("testGetExample", testGetExample),
        ("testPostExample", testPostExample),
        ("testHeadExample", testHeadExample),
    ]
}
