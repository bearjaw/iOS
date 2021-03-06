//
//  TLD.swift
//  DuckDuckGo
//
//  Copyright © 2018 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

class TLD {

    private(set) var tlds: [String: Int] = [:]

    var json: String {
        guard let data = try? JSONSerialization.data(withJSONObject: tlds, options: []) else { return "{}" }
        guard let json = String(data: data, encoding: .utf8) else { return "{}" }
        return json
    }

    init(bundle: Bundle = Bundle(for: TLD.self)) {
        guard let url = bundle.url(forResource: "tlds", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
        guard let tlds = json as? [String: Int] else { return }
        self.tlds = tlds
    }

    func domain(_ host: String?) -> String? {
        guard let host = host else { return nil }

        var parts = [String](host.components(separatedBy: ".").reversed())
        var stack = ""

        for index in 0 ..< parts.count {
            let part = parts[index]
            stack = !stack.isEmpty ? part + "." + stack : part
            guard tlds[stack] != nil else { break }
        }

        return stack
    }

}
