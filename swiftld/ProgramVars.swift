//
//  ProgramVars.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation

struct ProgramVars {
	var mh: voidPtr;
	var NXArgcPtr: UnsafePointer<Int>;
	var NXArgvPtr: UnsafePointer<UnsafePointer<CString>>;
	var environPtr: UnsafePointer<UnsafePointer<CString>>;
	var __prognamePtr: UnsafePointer<CString>;
}