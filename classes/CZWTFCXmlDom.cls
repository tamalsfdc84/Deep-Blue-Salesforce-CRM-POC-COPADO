public with sharing class CZWTFCXmlDom {
  // Constructor
  public CZWTFCXmlDom(string str) {
    parseFromString(str);
  }
  public CZWTFCXmlDom() {
    tffa.Logger.debug('Inside CZWTFCXmlDom default constructor');
  }
  public void parseFromString(string str) {
    XmlStreamReader reader = new XmlStreamReader(str);
    reader.setCoalescing(true);
    parseXmlReader(root, reader);
  }

  // debugging assistance
  public void dumpAll() {
    root.dumpAll();
  }

  integer count = 0;
  // given a parent node and a stream reader, populates the tree below here (recursive)
  void parseXmlReader(Element parent, XmlStreamReader reader) {
    try {
      while (reader.hasNext()) {
        if (reader.getEventType() == XmlTag.START_ELEMENT) {
          Element child = new Element(reader.getLocalName());

          // add all attributes from this element
          for (integer i = 0; i < reader.getAttributeCount(); i++) {
            child.attributes.put(reader.getAttributeLocalName(i), reader.getAttributeValueAt(i));
          }
          // add namespace info to each node/element ( for now storing on attributes map)
          for (integer j = 0; j < reader.getNamespaceCount(); j++) {
            string prefix = 'xmlns';
            if (reader.getnamespaceprefix(j) != null) {
              prefix = reader.getnamespaceprefix(j);
            }
            child.attributes.put(prefix, reader.getnamespaceuriat(j));
          }

          parent.appendChild(child); // add the new element to current parent

          if (child.nodeName == 'item') {
            count++;
          }
          if (child.nodeName == 'entry') {
            count++;
          }
          if (count > 10) {
            return;
          } // avoid a bug in xmlstream reader

          if (reader.hasNext()) {
            reader.next();
          } else {
            return;
          }
          parseXmlReader(child, reader); // recurse
        } else if (reader.getEventType() == XmlTag.END_ELEMENT) {
          reader.next();
          return;
        } else if (reader.getEventType() == XmlTag.CHARACTERS) {
          if (!reader.isWhitespace()) {
            parent.nodeValue += reader.getText(); // add text to current element
          }
          reader.next();
        } else {
          reader.next();
        }
      }
    } catch (Exception e) {
    }
  }

  // utility dom functions
  public Element ownerDocument() {
    return root;
  }

  // everything in the dom is found as childNodes under this root element
  public Element root = new Element('#document');
  public integer debug = 0;
  // dump out the element tree
  public String toXmlString() {
    return root.toXmlString();
  }

  /*
*  Element  class definition

  This following class implements a small portion of the wc3 xml dom model.
  Generally useful for simple XML return objects.

  For simplicity, Nodes are the same as Elements in this class.
  Nodes have text directly in them, rather than a seperate text node child
  The following describes the implemented portion, some w3c properties are now methods.

  Property    Description

  nodeName    Returns the name of a node, depending on its type
  nodeValue   Sets or returns the value of a node, depending on its type
  childNodes  Returns a NodeList of child nodes for a node
  parentNode  Returns the parent node of a node
  attributes      Returns a NamedNodeMap of attributes for the element, also contains name space entries

  getElementByTagName() Returns list of elements matching tag name (document and element)
  firstChild()    Returns the first child of a node
  removeChild()   Removes a child node
  appendChild()   Adds a new child node to the end of the list of children of a node
  getAttribute()  Returns the value of an attribute
  hasChildNodes()     Returns whether the element has any child nodes
  isEqualNode()   Checks if two nodes are equal
  textContent()   returns the textual content of a node
  cloneNode()     Clones a node
  hasAttributes()     Returns whether the element has any attributes
  isSameNode()    Checks if two nodes are the same node
  ownerDocument()     Returns the root element (document object) for a node

*/
  public class Element {
    //  Element(Element p, string n) {      parentNode = p;         nodeName = n;       }
    public Element(string n) {
      nodeName = n;
    }

    public void appendChild(Element e) {
      e.ParentNode = this;
      this.childNodes.add(e);
    }

    public void dumpAll() {
      dumpAll('');
    }
    public void dumpAll(string pre) {
      // node and all children
      tffa.Logger.debug(pre + this.nodeName + '->' + this.nodeValue + ' ' + this.attributes);
      for (Element c : this.childNodes) {
        c.dumpAll(pre + '   ');
      }
    }
    public string toXmlString() {
      string ret = '<' + this.nodeName + ' ';
      for (string a : attributes.keySet()) {
        ret += a + '=\'' + attributes.get(a) + '\' ';
      }
      ret += '>';
      if (nodeValue == '') {
        ret += '\n';
      }
      for (Element c : this.childNodes) {
        ret += c.toXmlString(); //+ '\n';
      }
      if (nodeValue != '') {
        ret += nodeValue;
      }
      //else ret += '\n';
      return ret + '</' + this.nodeName + '>\n';
    }
    /*
     * experimental path based patern matching, sort of like xpath,
     * but simpler, just matches a path() string with the pattern supplied
     */
    // * /bookstore/book/.*
    // /.*book/.*
    // /.*/book$

    // properties
    public Element parentNode = null; // only root has a null parent
    public string nodeName = '';
    public string nodeValue = '';
    public List<Element> childNodes = new List<Element>();
    public map<String, String> attributes = new Map<String, String>();
  }
}