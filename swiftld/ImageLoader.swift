//
//  ImageLoader.swift
//  swiftld
//
//  Created by Sam Marshall on 6/27/14.
//  Copyright (c) 2014 Sam Marshall. All rights reserved.
//

import Foundation
import MachO

class ImageLoader {
	var fState: dyld_image_state = dyld_image_state.initialized;
	var fMachOData: MachHeaderPtr = UnsafePointer.null();
	var fSlide: uintptr_t = 0;
	var fDevice: dev_t;
	var fInode: ino_t;
	var fLastModified: time_t;
	
	init() {
		self.fState = dyld_image_state.terminated;
		self.fMachOData = UnsafePointer.null();
		self.fSlide = 0;
		self.fDevice = 0;
		self.fInode = 0;
		self.fLastModified = 0;
	}
	
	func setFileInfo(device: dev_t, inode: ino_t, modDate: time_t) -> Void {
		fDevice = device;
		fInode = inode;
		fLastModified = modDate;
	}
	
	func getState() -> dyld_image_state {
		return fState;
	}
	
	func setMapped(context: LinkContext) -> Void {
		fState = dyld_image_state.mapped;
		context.notifySingle(dyld_image_state.mapped, image:self);
	}
	
	
	
	func checkHeaderFlag(flag: CInt) -> CBool {
		var mh: mach_header = fMachOData.memory;
		var result = UInt(mh.flags) & UInt(flag);
		return (result != 0);
	}
	
	func checkFileType(type: CInt) -> CBool {
		var mh: mach_header = self.fMachOData.memory;
		var result = UInt(mh.filetype) & UInt(type);
		return (result != 0);
	}
	
	func isBundle() -> CBool {
		return self.checkFileType(MH_BUNDLE);
	}
	
	func isDylib() -> CBool {
		return self.checkFileType(MH_DYLIB);
	}
	
	func isExecutable() -> CBool {
		return self.checkFileType(MH_EXECUTE);
	}
	
	func segmentsMustSlideTogether() -> CBool {
		return true;
	}
	
	func segmentsCanSlide() -> CBool {
		return self.isDylib() || self.isBundle() || self.isPositionIndependentExecutable();
	}
	
	func isPositionIndependentExecutable() -> CBool {
		return self.checkFileType(MH_EXECUTE) && self.checkHeaderFlag(MH_PIE);
	}
	
	func usesTwoLevelNameSpace() -> CBool {
		return self.checkHeaderFlag(MH_TWOLEVEL);
	}
	
	func forceFlat() -> CBool {
		return self.checkHeaderFlag(MH_FORCE_FLAT);
	}
	
	func isPrebindable() -> CBool {
		return self.checkHeaderFlag(MH_PREBOUND);
	}
	
	func hasCoalescedExports() -> CBool {
		return self.checkHeaderFlag(MH_WEAK_DEFINES);
	}
	
	func hasReferencesToWeakSymbols() -> CBool {
		return self.checkHeaderFlag(MH_BINDS_TO_WEAK);
	}
	
	func participatesInCoalescing() -> CBool {
		return self.checkHeaderFlag(MH_WEAK_DEFINES | MH_BINDS_TO_WEAK);
	}
	
	func setSlide(slide: uintptr_t) -> Void {
		fSlide = slide;
	}
	
	func doBindLazySymbol(lazyPointer: UnsafePointer<uintptr_t>, context: LinkContext) -> uintptr_t {
		let twoLevel = self.usesTwoLevelNameSpace();
		
		return 0;
	}
}