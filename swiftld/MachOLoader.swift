//
//  MachOLoader.swift
//  swiftld
//
//  Created by Sam Marshall on 6/28/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation
import MachO


class MachOLoader : ImageLoader {
	var fSegments: LoaderGenericSegment[];
	
	init() {
		self.fSegments = [];
	}
	
	func instantiateMainExecutable(mh: MachHeaderPtr, slide: uintptr_t, context: LinkContext) -> ImageLoader {
		return ImageLoader();
	}
	
	func instantiateFromFile(path: CString, fd: CInt, firstPage: HeaderPage, offsetInFat: UInt64, lenInFat: UInt64, info: stat, context: LinkContext) -> ImageLoader {
		return ImageLoader();
	}
	
	func segLoadCommand(segIndex: CInt) ->  LoaderGenericSegment {
		return self.fSegments[Int(segIndex)];
	}
	
	func segName(segIndex: CInt) -> CString {
		return convert(self.segLoadCommand(segIndex).segment.segName);
	}
	
	func segSize(segIndex: CInt) -> uintptr_t {
		return uintptr_t(self.segLoadCommand(segIndex).data.vmPosition.size);
	}
	
	func segFileSize(segIndex: CInt) -> uintptr_t {
		return uintptr_t(self.segLoadCommand(segIndex).data.filePosition.size);
	}
	
	func segHasTrailingZeroFill(segIndex: CInt) -> CBool {
		return ( self.segWriteable(segIndex) && self.segSize(segIndex) > self.segFileSize(segIndex));
	}
	
	func segFileOffset(segIndex: CInt) -> uintptr_t {
		return uintptr_t(self.segLoadCommand(segIndex).data.filePosition.addr);
	}
	
	func segReadable(segIndex: CInt) -> CBool {
		return ( (self.segLoadCommand(segIndex).info.initprot & VM_PROT_READ) != 0);
	}
	
	func segWriteable(segIndex: CInt) -> CBool {
		return ( (self.segLoadCommand(segIndex).info.initprot & VM_PROT_WRITE) != 0);
	}
	
	func segUnaccessible(segIndex: CInt) -> CBool {
		return (self.segLoadCommand(segIndex).info.initprot == 0);
	}
	
	func segHasPreferedLoadAddress(segIndex: CInt) -> CBool {
		return (self.segPreferedLoadAddress(segIndex) != 0);
	}
	
	func segPreferedLoadAddress(segIndex: CInt) -> uintptr_t {
		return uintptr_t(self.segLoadCommand(segIndex).data.vmPosition.addr);
	}
	
	func segActualLoadAddress(segIndex: CInt) -> uintptr_t {
		return self.segPreferedLoadAddress(segIndex) + self.fSlide;
	}
	
	func segActualEndAddress(segIndex: CInt) -> uintptr_t {
		return self.segActualLoadAddress(segIndex) + self.segSize(segIndex);
	}
	
	
}