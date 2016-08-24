// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import AsyncDisplayKit

final class ASDKCollectionViewController<ContentNodeType: ASCellNode where ContentNodeType: DataBinder>: ASViewController, ASCollectionDelegate, ASCollectionDataSource {

	let data: [ContentNodeType.DataType]
    let flowLayout: UICollectionViewFlowLayout

    init(data: [ContentNodeType.DataType]) {
        self.data = data
        self.flowLayout = UICollectionViewFlowLayout()
		let collection = ASCollectionNode(collectionViewLayout: self.flowLayout)
        super.init(node: collection)
		collection.delegate = self
		collection.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	func collectionView(collectionView: ASCollectionView, nodeBlockForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
		let item = data[indexPath.item]
		return {
			let node = ContentNodeType()
			node.setData(item)
			return node
		}
	}
	
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
	
	func collectionView(collectionView: ASCollectionView, constrainedSizeForNodeAtIndexPath indexPath: NSIndexPath) -> ASSizeRange {
		let width = collectionView.bounds.width
		return ASSizeRange(min: CGSize(width: width, height: 0), max: CGSize(width: width, height: .max))
	}
	
	private var hasLaidOut = false
	override func viewWillLayoutSubviews() {
		if hasLaidOut == true { return }
		hasLaidOut = true
		let collection = view as! ASCollectionView
		collection.reloadDataImmediately()
		assert(collection.numberOfItemsInSection(0) == data.count)
	}
}
