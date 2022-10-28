public with sharing class CZWTFCXMLSerializer {
  //Private Member
  private boolean serializeNulls = true; // Serializes XML nodes even if the content is null
  private string rootElement; // Root element to wrap around the serialized string.
  private Set<string> deSerializeAsArrayNodes = new Set<string>(); // Collection of node names to be deserialized as array.

  /*
   @Description    : deSerializes the xml string into collection of primitive data types.
   @Parameter      : xmlString = xml String to deSerialize
   @Returns        : collection of primitive data types
 */
  public object deSerializeUnTyped(string xmlString) {
    return xmlToUnTyped(xmlString);
  }

  /*
   @Description    : deSerializes the xml string into collection of primitive data types.
   @Parameter      : xmlString = xml String to deSerialize
   @Parameter      : deSerializeNodesAsArray  = collection of node names to deserialize as array (Even if xml representation is not an array)
   @Returns        : collection of primitive data types
 */
  private Map<string, object> xmlToUnTyped(string xmlString) {
    CZWTFCXmlDom xd = new CZWTFCXmlDom(xmlString);
    CZWTFCXmlDom.Element document = xd.ownerDocument();
    return (Map<string, object>) parseNode(document);
  }

  /*
   @Description    : parses an XML node
   @Parameter      : e = xml node (of type CZWTFCXmlDom.Element)
   @Returns        : object
 */
  private object parseNode(CZWTFCXmlDom.Element e) {
    if (e.childNodes.size() > 0) {
      return complexNodeToMap(e);
    } else {
      return e.nodeValue;
    }
  }

  /*
   @Description    : Converts a complex xml node to collection of primitive types.
   @Parameter      : e = xml node (of type CZWTFCXmlDom.Element)
   @Returns        : Map representation of the node.
 */
  private Map<string, object> complexNodeToMap(CZWTFCXmlDom.Element e) {
    Map<string, object> cNodeMap = new Map<string, object>();
    for (CZWTFCXmlDom.Element cNode : e.childNodes) {
      if (cNodeMap.containsKey(cNode.nodeName)) {
        object o = cNodeMap.get(cNode.nodeName);
        if (o instanceof List<object>) {
          ((List<object>) o).add(parseNode(cNode));
        } else {
          cNodeMap.put(cNode.nodeName, new List<object>{ o, parseNode(cNode) });
        }
      } else {
        cNodeMap.put(
          cNode.nodeName,
          deSerializeAsArrayNodes.contains(cNode.nodeName.toLowerCase()) ? new List<object>{ parseNode(cNode) } : parseNode(cNode)
        );
      }
    }
    return cNodeMap;
  }
}