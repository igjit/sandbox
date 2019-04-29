(* 整数と整数演算 *)

3 + 7 ;;

1 mod 2 + 3 * 4 / 5 ;;

1 mod (2 + 3 * (4 / 5)) ;;

-3 - -7 ;;

(* いろいろな式と値、型 *)

1.2 -. 3.4 ;;

5.6 +. 7.8 *. 9.0 ;;

"hello" ^ "world" ;;

(* 標準の関数を利用する *)

float_of_int 123 ;;

float_of_int (3 + 7) ;;

print_int 12345 ;;

print_newline() ;;

(* 標準のライブラリを利用する *)

Random.init 12345 ;;

Random.int 10 ;;

Sys.getcwd () ;;

#load "str.cma" ;;

Str.global_replace (Str.regexp "f...") "xxxx" "abcdefghijkl" ;;

(* 変数や関数を定義する *)

let pi = 3.141592653589793 ;;

2.0 *. 10.0 *. pi ;;

let area_of_circle r = r *. r *. pi ;;

area_of_circle 10.0 ;;

(* 複数の引数 *)

let distance (x, y) = sqrt (x *. x +. y *. y) ;;

distance (2.0, 2.0) ;;

let distance x y = sqrt (x *. x +. y *. y) ;;

distance 2.0 2.0 ;;

(* 再帰関数 *)

let rec factorial n =
  if n = 1 then 1 else
    factorial (n - 1) * n ;;

factorial 10 ;;

(* 高階関数、無名関数 *)

let f g = g (g 3 7) (g 123 456) ;;

let g1 x y = x + y in f g1 ;;

f (fun x y -> x + y) ;;

(* 関数としての二引数演算子 *)

f (+) ;;
f ( * ) ;;

(* 関数を定義するスタイル *)

let distance = fun x y -> sqrt (x *. x +. y *. y) ;;

let distance = fun x -> fun y -> sqrt (x *. x +. y *. y) ;;

(* 再帰データ型 *)

type int_tree = Leaf of int | Node of int_tree * int_tree ;;

Leaf 123 ;;

Node(Leaf 123, Leaf 456) ;;

Node(Leaf 123, Node(Leaf 456, Leaf 789)) ;;

let rec make_random_tree () =
  if Random.int 2 = 0 then Leaf(Random.int 10) else
    Node(make_random_tree (), make_random_tree ()) ;;

(* パターンマッチング *)

let rec int_tree_sum t =
  match t with
    Leaf i -> i
  | Node(l, r) -> int_tree_sum l + int_tree_sum r ;;

int_tree_sum (Node(Node(Leaf 3, Leaf 5), Leaf 7)) ;;

let rec int_tree_sum = function
    Leaf i -> i
  | Node(l, r) -> int_tree_sum l + int_tree_sum r ;;

(* 多相データ型と多相関数 *)

type 'a tree = Leaf of 'a | Node of 'a tree * 'a tree ;;

Leaf 123 ;;

Node(Leaf 4.56, Leaf 78.9) ;;

Node(Leaf "abc", Node(Leaf "def", Leaf "ghi")) ;;

let rec height = function
    Leaf _ -> 0
  | Node(l, r) -> 1 + max (height l) (height r) ;;

(* リスト *)

let rec make_random_list () =
  if Random.int 3 = 0 then [] else
    Random.int 10 :: make_random_list () ;;

make_random_list() ;;

let rec length = function
    [] -> 0
  | _ :: list -> 1 + length list ;;

length [1; 2; 3] ;;

(* 命令型言語の機能: 参照 *)

let counter = ref 0 ;;

let count () =
  counter := !counter + 1;
  !counter ;;

count () ;;

(* 例外処理 *)

exception Zero ;;

let rec multiply_int_list = function
    [] -> 1
  | i :: l ->
     if i = 0 then raise Zero else
       i * multiply_int_list l ;;

multiply_int_list [2; 3; 4] ;;

multiply_int_list [5; 0; 6] ;;

try
  multiply_int_list [5; 0; 6]
with Zero -> 0 ;;
