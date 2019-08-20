# Swift Generics JSON Parser

JSON parser can take an input of an URL and object of any type.
Input type needs conform to the decodable protocol, and its properties match JSON keys.

It can handle array JSON structure of the given objects.

downloadList<T: Decodable> function returns an error or an array of successfully parsed objects.
