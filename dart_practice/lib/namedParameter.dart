
void main(){
  print(add(first:10,second:5));
}
int add({
  required int first,
  required int second,
  int? third,
  int? fourth,
  int? fifth,
}){
 return first+second+(third ?? 0)+(fourth ?? 0)+(fifth ?? 0);
}