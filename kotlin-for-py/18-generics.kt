// Generic type parameters

class TreeNode<T>(val value: T?, val next: TreeNode<T>? = null)

val n = TreeNode("foo", TreeNode("bar"))
n.next!!.value

fun <T> makeLinkedList(vararg elements: T): TreeNode<T>? {
    var node: TreeNode<T>? = null
    for (element in elements.reversed()) {
        node = TreeNode(element, node)
    }
    return node
}

val l = makeLinkedList("foo", "bar")
l?.value
l?.next?.value
