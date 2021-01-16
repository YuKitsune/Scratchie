//
// Created by Eoin Motherway on 13/1/21.
//

import Foundation

class MarkdownParser {

    let boldRegex = try! NSRegularExpression(pattern: "(\\*{2}).*?(\\*{2})")

    func tokenize(_ text: String) -> [MarkdownToken] {
        let lines = text.split(separator: "\n")
        var tokens = [MarkdownToken]()

        var currentCodeBlock: MarkdownCodeBlock?
        lines.forEach{ line in

            // If we've hit the code block identifier,
            //  either finish off the current code block, or start a new one
            // Todo: Check suffix as well
            if line.hasPrefix("```") {
                if currentCodeBlock == nil {
                    currentCodeBlock = MarkdownCodeBlock(value: String(line))
                } else {
                    tokens.append(currentCodeBlock!)
                    currentCodeBlock = nil
                }

                return
            }

            // If we're in a code block, append the current line
            if currentCodeBlock != nil {
                currentCodeBlock?.value.append("\n\(line)")
                return
            }

            // Headings
            if line.hasPrefix("#") {
                let headingToken = MarkdownHeading(value: String(line))
                tokens.append(headingToken)
                return
            }

            // Horizontal Rule
            if line.count >= 3 &&
               line.allSatisfy({ character in
                character == "*" || character == "-" || character == "_"
               }) {
                let horizontalRuleToken = MarkdownHorizontalRule(value: String(line))
                tokens.append(horizontalRuleToken)
                return
            }

            // Quote
            if line.hasPrefix(">") {

                // If the last line was also a quote, then just add this one to it
                if tokens.last is MarkdownQuote {
                    tokens.last?.value.append("\n\(line)")
                } else {
                    let quoteToken = MarkdownQuote(value: String(line))
                    tokens.append(quoteToken)
                }

                return
            }

            // Todo: Table

            // Made it this far, can only be a paragraph
            let paragraphToken = MarkdownParagraph(value: String(line))
            tokens.append(paragraphToken)
        }

        // Checked all lines, make sure there is no in-progress code-block
        if currentCodeBlock != nil {
            tokens.append(currentCodeBlock!)
            currentCodeBlock = nil
        }

        return tokens
    }
}
