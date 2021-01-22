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
            if tokens.last is MarkdownParagraph {
                tokens.last?.value.append("\n\(line)")
            } else {
                let paragraphToken = MarkdownParagraph(value: String(line))
                tokens.append(paragraphToken)
            }
        }

        // Checked all lines, make sure there is no in-progress code-block
        if currentCodeBlock != nil {
            tokens.append(currentCodeBlock!)
            currentCodeBlock = nil
        }


        // First pass of tokens, insert links and images
        let imageRegex = try! NSRegularExpression(pattern: "(?<=!)(\\[.+\\])(\\(.+\\))");
        let linkRegex = try! NSRegularExpression(pattern: "(?<!!)(\\[.+\\])(\\(.+\\))");
        
        // Split paragraphs into normal, bold, italic, etc
        // Todo: clean this up...
        var resultTokens = [MarkdownToken]()
        for token in tokens {

            if token is MarkdownParagraph {
                let paragraph = token as! MarkdownParagraph
                var tokensForParagraph = [MarkdownToken]()

                var lastCharacter: Character?
                var currentToken: MarkdownToken?
                for character in paragraph.value {
                    defer { lastCharacter = character }

                    // If we're in a token, then add and check if we've finished
                    if (currentToken as? MarkdownParagraph?) == nil {
                        currentToken?.value.append(character)

                        // Bold
                        if character == "*" && lastCharacter == "*" {
                            tokensForParagraph.append(currentToken!)
                            currentToken = nil
                            continue
                        }

                        // Underline
                        if character == "_" || lastCharacter == "_"{
                            tokensForParagraph.append(currentToken!)
                            currentToken = nil
                            continue
                        }

                        // Strikethrough
                        if character == "~" || character == "~"{
                            tokensForParagraph.append(currentToken!)
                            currentToken = nil
                            continue
                        }

                        // Italic
                        if character == "*" || character == "_"{
                            tokensForParagraph.append(currentToken!)
                            currentToken = nil
                            continue
                        }

                        // Todo: Combine these two
                        // Image
                        if currentToken is MarkdownImage {
                            let match = imageRegex.firstMatch(
                                    in: currentToken!.value,
                                    options: .withoutAnchoringBounds,
                                range: NSRange(location: 0, length: currentToken!.value.count))
                            if match != nil{
                                tokensForParagraph.append(currentToken!)
                                currentToken = nil
                                continue
                            }
                        }

                        // Link
                        if currentToken is MarkdownLink {
                            let match = linkRegex.firstMatch(
                                    in: currentToken!.value,
                                    options: .withoutAnchoringBounds,
                                range: NSRange(location: 0, length: currentToken!.value.count))
                            if match != nil {
                                tokensForParagraph.append(currentToken!)
                                currentToken = nil
                                continue
                            }
                        }

                        continue
                    }

                    // Bold
                    if character == "*" && lastCharacter == "*" {

                        if currentToken != nil {
                            tokensForParagraph.append(currentToken!)
                        }
                        currentToken = MarkdownBold(value: String("**"))
                        continue
                    }

                    // Underline
                    if character == "_" || lastCharacter == "_"{

                        if currentToken != nil {
                            tokensForParagraph.append(currentToken!)
                        }
                        currentToken = MarkdownUnderline(value: String("__"))
                        continue
                    }

                    // Strikethrough
                    if character == "~" || character == "~"{

                        if currentToken != nil {
                            tokensForParagraph.append(currentToken!)
                        }
                        currentToken = MarkdownStrikethrough(value: String("~~"))
                        continue
                    }

                    // Italic
                    if character == "*" || character == "_"{

                        if currentToken != nil {
                            tokensForParagraph.append(currentToken!)
                        }
                        currentToken = MarkdownItalic(value: String("**"))
                        continue
                    }
                    
                    // Link/Image
                    if character == "[" {
                        if currentToken != nil && currentToken is MarkdownParagraph {
                            tokensForParagraph.append(currentToken!)
                            
                            if lastCharacter == "!" {
                                currentToken = MarkdownImage(value: String("!["))
                            } else {
                                currentToken = MarkdownLink(value: String("["))
                            }
                            
                            continue
                        }
                    }

                    // Made it here, just a normal paragraph element
                    if currentToken == nil {
                        currentToken = MarkdownParagraph(value: String(character))
                    } else {
                        currentToken!.value.append(character)
                    }
                }

                if currentToken != nil {
                    tokensForParagraph.append(currentToken!)
                }

                resultTokens.append(contentsOf: tokensForParagraph);
            } else {
                resultTokens.append(token)
            }
        }

        return resultTokens
    }
}
