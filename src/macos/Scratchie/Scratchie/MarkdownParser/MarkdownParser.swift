//
// Created by Eoin Motherway on 13/1/21.
//

import Foundation

// Todo: This needs a big refactor. Very unhappy with it...
class MarkdownParser {

    func tokenize(_ text: String) -> [MarkdownToken] {

        // Split the input into individual lines
        let lines = text.split(separator: "\n")
        var tokens = [MarkdownToken]()

        var currentCodeBlock: MarkdownCodeBlock?
        for line in lines {

            // First check tokens which consist of multiple lines

            // Code block
            if line.hasPrefix("```") {
                if currentCodeBlock == nil {
                    currentCodeBlock = MarkdownCodeBlock(value: String(line))
                } else {
                    tokens.append(currentCodeBlock!)
                    currentCodeBlock = nil
                }

                continue
            }

            // If we're in a code block, append the current line
            if currentCodeBlock != nil {
                currentCodeBlock?.value.append("\n\(line)")
                continue
            }

            // Quote
            if line.hasPrefix(">") {
                // If the last line was also a quote then we can just append this line to the quote
                if let quote = tokens.last as? MarkdownQuote {
                    quote.value.append("\n\(line)")
                } else {
                    let quoteToken = MarkdownQuote(value: String(line))
                    tokens.append(quoteToken)
                }

                continue
            }

            // Then check for tokens which consist of one whole line

            // Headings
            if line.hasPrefix("#") {
                let headingToken = MarkdownHeading(value: String(line))
                tokens.append(headingToken)
                continue
            }

            // Horizontal Rule
            if line.count >= 3 &&
               line.allSatisfy({ character in
                character == "*" || character == "-" || character == "_"
               }) {
                let horizontalRuleToken = MarkdownHorizontalRule(value: String(line))
                tokens.append(horizontalRuleToken)
                continue
            }

            // Made it this far, can only be a paragraph
            if let paragraph = tokens.last as? MarkdownParagraph {
                paragraph.value.append("\n\(line)")
            } else {
                let paragraphToken = MarkdownParagraph(value: String(line))
                tokens.append(paragraphToken)
            }
        }

        // Checked all lines, make sure there is no unfinished code-block
        if currentCodeBlock != nil {
            tokens.append(currentCodeBlock!)
            currentCodeBlock = nil
        }

        // First pass complete, now we check for in-line tokens within paragraphs
        var resultTokens = [MarkdownToken]()
        for token in tokens {
            if let paragraph = token as? MarkdownParagraph {

                // We've hit a paragraph, check for in-line tokens
                var tokensForParagraph = [MarkdownToken]()
                var lastCharacter: Character?
                var currentToken: MarkdownToken?
                for character in paragraph.value {

                    // Update the last character once this loop re-itterates
                    defer { lastCharacter = character }

                    // If we're currently working on a token that isn't a paragraph, append and check if it's finished
                    if currentToken != nil && (currentToken as? MarkdownParagraph?) == nil {
                        currentToken!.value.append(character)

                        if currentToken!.isComplete() {
                            tokensForParagraph.append(currentToken!)
                            currentToken = nil
                        }
                        
                        continue
                    }

                    // Check for each token type

                    // Bold
                    if character == "*" && lastCharacter == "*" {

                        if currentToken != nil {
                            tokensForParagraph.append(currentToken!)
                        }
                        currentToken = MarkdownBold(value: "**")
                        continue
                    }

                    // Underline
                    if character == "_" || lastCharacter == "_"{

                        if currentToken != nil {
                            tokensForParagraph.append(currentToken!)
                        }
                        currentToken = MarkdownUnderline(value: "__")
                        continue
                    }

                    // Strikethrough
                    if character == "~" || character == "~" {

                        if currentToken != nil {
                            tokensForParagraph.append(currentToken!)
                        }
                        currentToken = MarkdownStrikethrough(value: "~~")
                        continue
                    }

                    // Italic
                    if character == "*" || character == "_"{

                        if currentToken != nil {
                            tokensForParagraph.append(currentToken!)
                        }
                        currentToken = MarkdownItalic(value: String(repeating: character, count: 2))
                        continue
                    }
                    
                    // Link/Image
                    if character == "[" {
                        if currentToken != nil && currentToken is MarkdownParagraph {
                            tokensForParagraph.append(currentToken!)
                            
                            if lastCharacter == "!" {
                                currentToken = MarkdownLink(characters: [lastCharacter!, character])
                            } else {
                                currentToken = MarkdownLink(character: character)
                            }
                            
                            continue
                        }
                    }

                    // Couldn't find any matching tokens prefixes, it's just a paragraph
                    if currentToken == nil {
                        currentToken = MarkdownParagraph(value: String(character))
                        continue
                    } else {
                        currentToken?.value.append(character)
                    }
                }

                if currentToken != nil {
                    tokensForParagraph.append(currentToken!)
                }

                resultTokens.append(contentsOf: tokensForParagraph);
            } else {
                // Not a paragraph, just add it as it is
                resultTokens.append(token)
            }
        }

        return resultTokens
    }
}
