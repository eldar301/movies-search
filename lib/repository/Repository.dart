abstract class Repository<T> {
  Future<T> get(int index);
}