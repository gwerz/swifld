//
//  MachOClass.swift
//  swiftld
//
//  Created by Sam Marshall on 6/28/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation


class MachOBinary {
	var header: LoaderGenericHeader;
	var segments: MachOSegment[];
	
	init() {
		self.header = LoaderGenericHeader();
		self.segments = [];
	}
}

class MachOSegment {
	var segment: LoaderGenericSegment;
	var sections: LoaderGenericSection[];
	
	init() {
		self.segment = LoaderGenericSegment();
		self.sections = [];
	}
}