//
//  Enums.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation

enum dyld_image_state: Int {
	case mapped = 10
	case dependents_mapped = 20
	case rebased = 30
	case bound = 40
	case dependents_initialized = 45
	case initialized = 50
	case terminated = 60
}

enum RestrictedReason {
	case Not
	case SetGUid
	case Segment
	case Entitlements
}

enum PrebindMode {
	case All
	case SplitSeg
	case AllButApp
	case None
}

enum BindingOptions {
	case None
	case LazyPointers
	case NeverSetLazyPointers
}

enum SharedRegionMode {
	case Use
	case Private
	case Dont
	case Cache
}