import Foundation

/*:

This file exports the typealias `AnnotationInfo` and the function `loadAnnotationData()`,
which loads the data set defining the relationship between emoji characters and annotations of
those characters.

This data set is in the embedded XML file "en.xml", which is copied directly from the
Unicode Common Locale Data Repository (CLDR).

To get an updated copy of this file, do the following:

1. Get CLDR data from <http://cldr.unicode.org/index/downloads>
2. Unzip core.zip
3. Go to core/common/annotations/en.xml

The resources of this playground also incldue the file "emoji-data.txt", which
defines other emoji-related data, such as character alias names, which are officially
distinct from their actual names. Left as an exercise for the reader. :)

*/

/**

A partial, noncompliant representation of a _UnicodeSet_, which is a set
of _UnicodeString_s.

A UnicodeSet can be represented via a "pattern string". This struct ignores
and mis-handles many valid patterns, but it suffices for the purpose of parsing
the pattern strings that appear in the Unicode annotation data.

Reference:
http://userguide.icu-project.org/strings/unicodeset

*/
struct UnicodeSet
{
  let pattern: String

  /** Initialize
  :pattern: a UnicodeSet pattern
  */
  init(pattern: String) {
    self.pattern = pattern
  }

  var characters: [Character] {
    let stringChars = Array(pattern.characters)
    guard
      let firstChar = stringChars.first where firstChar == "[",
      let lastChar = stringChars.last where lastChar == "]" else {
        fatalError("unable to parse attribute value as UnicodeSet")
    }
    let containedCharSet = stringChars[1..<(stringChars.count - 1)]
    // ignore "string value" patterns
    let finalSet: [Character] = containedCharSet.filter({ $0 != "}" && $0 != "{"})
    return finalSet
  }
}

public typealias AnnotationInfo = (codePoints: [Character], annotations: [String])

private func convert(codePointsAttributeValue: String, annotationBody: String) -> AnnotationInfo
{
  return (
    codePoints: UnicodeSet(pattern: codePointsAttributeValue).characters,
    annotations: annotationBody.characters.split(";").map({ String($0) }).map({ $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())  })
  )
}

/**

XML parser delegate for the CLDR file,
core.zip/common/annotations/en.xml.

Accumulates an array of Annotation structs, ignoring document structure.

*/
class AnnotationsAccumulator: NSObject, NSXMLParserDelegate
{
  let requiredElementName = "annotation"
  let codePointsAttributeName = "cp"

  var output: [AnnotationInfo] = []

  var isParsingAnnotationElement: Bool = false
  var currentCodePoints: String?
  var currentBody: String?

  override init() {
    self.output.reserveCapacity(1500)
  }

  func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
    if elementName == requiredElementName && isParsingAnnotationElement == false
    {
      if let codePoints = attributeDict[codePointsAttributeName] {
        isParsingAnnotationElement = true
        currentCodePoints = codePoints
      }
    }
  }

  func parser(parser: NSXMLParser, foundCharacters string: String) {
    if isParsingAnnotationElement {
      self.currentBody = string
    }
  }

  func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == requiredElementName && isParsingAnnotationElement == true {
      if let cp = self.currentCodePoints, body = self.currentBody {
        let a = convert(cp, annotationBody: body)
        output.append(a)
        currentCodePoints = nil
        currentBody = nil
        isParsingAnnotationElement = false
      }
    }
  }
}

public func loadUnicodeAnnotationData() -> [AnnotationInfo]
{
  let annotationspath = NSBundle.mainBundle().URLForResource("en", withExtension: "xml")!
  let inputStream = NSInputStream(URL: annotationspath)!
  let parser = NSXMLParser(stream: inputStream)
  let delegate  = AnnotationsAccumulator()
  parser.delegate = delegate
  parser.shouldProcessNamespaces = false
  parser.parse()
  return delegate.output
}
