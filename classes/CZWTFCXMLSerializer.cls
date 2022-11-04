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

  public string serialize(object objectToSerialize) {
    object deSerialized = JSON.deserializeUntyped(JSON.serialize(objectToSerialize));
    return !string.isEmpty(rootElement)
      ? Wrap(rootElement, serialize((Map<string, object>) deSerialized))
      : serialize((Map<string, object>) deSerialized);
  }

  private string serialize(Map<string, object> objectMap) {
    string xmlString = '';
    for (string key : objectMap.keySet()) {
      object o = objectMap.get(key);
      if (o == null) {
        if (this.SerializeNulls)
          xmlString += wrap(key, null);
      } else if (o instanceof List<object>)
        xmlString += serialize((List<object>) o, key);
      else if (o instanceof Map<string, object>)
        xmlString += wrap(key, serialize((Map<string, object>) o));
      else
        xmlString += wrap(key, string.valueOf(o));
    }
    return xmlString;
  }

  public string serialize(object objectToSerialize, boolean suppressApexObjectNulls, string addRootElementName) {
    this.serializeNulls = !suppressApexObjectNulls;
    this.rootElement = addRootElementName;
    return serialize(objectToSerialize);
  }

  private string serialize(List<object> objectList, string key) {
    string xmlString = '';
    for (object o : objectList) {
      if (o instanceof string)
        xmlString += wrap(key, string.valueOf(o));
      else if (o instanceof List<object>)
        xmlString += wrap(key, serialize((List<object>) o, key));
      else
        xmlString += wrap(key, serialize((Map<string, object>) o));
    }
    return xmlString;
  }

  private string wrap(string key, string value) {
    return (string.isNotBlank(value) || serializeNulls)
      ? ('<' + key + '>' + (string.isBlank(value) ? '' : value) + '</' + key + '>')
      : value;
  }
}