//
//  MappedRegion.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation

struct MappedRegion {
	var address: uintptr_t;
	var size: size_t;
}