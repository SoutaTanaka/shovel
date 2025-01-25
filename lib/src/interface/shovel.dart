abstract interface class Shovel {
  T dig<T>();

  T digWithArg<T, A>(A arg);
}
