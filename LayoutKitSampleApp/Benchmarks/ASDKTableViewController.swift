// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import AsyncDisplayKit

final class ASDKTableViewController<ContentNodeType: ASCellNode>: ASViewController<ASTableNode>, ASTableDelegate, ASTableDataSource where ContentNodeType: DataBinder {

	let data: [ContentNodeType.DataType]

    init(data: [ContentNodeType.DataType]) {
        self.data = data
		let table = ASTableNode(style: .plain)
        super.init(node: table)
		table.delegate = self
		table.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
		let item = data[(indexPath as NSIndexPath).item]
		return {
			let node = ContentNodeType()
			node.setData(item)
			return node
		}
	}

	func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	fileprivate var hasLaidOut = false
	override func viewWillLayoutSubviews() {
		if hasLaidOut == true { return }
		hasLaidOut = true
		node.reloadData()
		node.waitUntilAllUpdatesAreCommitted()
		assert(node.numberOfRows(inSection: 0) == data.count)
	}
}
