//
//  File.swift
//  
//
//  Created by Tristan Celder on 19/06/2019.
//

import Combine

// MARK: - Signal value definition

public enum Signal <Input, Failure: Error> {
    case subscription
    case input(Input)
    case completion(Subscribers.Completion<Failure>)
}

// MARK: - Equatable conformance

extension Signal: Equatable where Input: Equatable, Failure: Equatable {
    
    public static func ==(lhs: Signal<Input, Failure>, rhs: Signal<Input, Failure>) -> Bool {
        switch (lhs, rhs) {
        case (.subscription, .subscription):
            return true
        case (.input(let lhsInput), .input(let rhsInput)):
            return (lhsInput == rhsInput)
        case (.completion(let lhsCompletion), .completion(let rhsCompletion)):
            return completionsMatch(lhs: lhsCompletion, rhs: rhsCompletion)
        default:
            return false
        }
    }
    
    fileprivate static func completionsMatch(lhs: Subscribers.Completion<Failure>, rhs: Subscribers.Completion<Failure>) -> Bool {
        switch (lhs, rhs) {
        case (.finished, .finished):
            return true
        case (.failure(let lhsError), .failure(let rhsError)):
            return (lhsError == rhsError)
        default:
            return false
        }
    }
}

public protocol SignalConvertible {
    
    associatedtype Input
    associatedtype Failure: Error
    
    init(_ signal: Signal<Input, Failure>)
    var signal: Signal<Input, Failure> { get }
}

extension Signal: SignalConvertible {
    
    public init(_ signal: Signal<Input, Failure>) {
        self = signal
    }
    
    public var signal: Signal<Input, Failure> {
        return self
    }
}
