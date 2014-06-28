//
//  main.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation
import MachO
import Darwin

var error_string: CString = "";

typealias MachHeaderPtr = UnsafePointer<LoaderGenericHeader>;
typealias MachSegCmdPtr = UnsafePointer<LoaderGenericSegment>
typealias ImageCallback = (MachHeaderPtr, intptr_t);
typealias UndefinedHandler = (CString);
typealias ImageLocator = (CString);

var sExecPath: CString;
var sExecShortName: CString;
var sMainExecutableMachheader: MachHeaderPtr;
var sHostCPU: cpu_type_t;
var sHostCPUsubtype: cpu_subtype_t;
var sMainExecutable: ImageLoader;
var sProcessIsRestricted: CBool;
var sRestrictedReason: RestrictedReason = RestrictedReason.Not;
var sInsertedDylibCount: UInt = 0;
var sAllImages: ImageLoader[] = [];
var sImageRoots: ImageLoader[] = [];
var sImageFilesNeedingTermination: ImageLoader[] = [];
var sImageFilesNeedingDOFUnregistration: RegisteredDOF[] = [];
var sAddImageCallbacks: ImageCallback[] = [];
var sRemoveImageCallbacks: ImageCallback[] = [];


var sMappedRanges: MappedRange[] = [];

var gLinkContext: LinkContext;
var gProcessInfo: dyld_all_image_infos;


println("hello world");