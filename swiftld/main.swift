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

typealias intptr_t = Int
typealias cpu_type_t = CInt
typealias cpu_subtype_t = CInt
typealias cpu_threadtype_t = CInt

struct mach_header {
	var magic: UInt32 /* mach magic number identifier */
	var cputype: cpu_type_t /* cpu specifier */
	var cpusubtype: cpu_subtype_t /* machine specifier */
	var filetype: UInt32 /* type of file */
	var ncmds: UInt32 /* number of load commands */
	var sizeofcmds: UInt32 /* the size of all the load commands */
	var flags: UInt32 /* flags */
}
typealias MachHeaderPtr = UnsafePointer<mach_header>;
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