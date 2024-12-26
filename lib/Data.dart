
class Book {
   String ISBN;
   String bookTitle;
   String bookAuthor;
   int yearOfPublication;
   String publisher;
   String imageUrlMedium;

   Book(this.ISBN, this.bookTitle, this.bookAuthor, this.yearOfPublication,
      this.publisher, this.imageUrlMedium);


   @override
   String toString() {
     return "Book{" +
         "ISBN='" + ISBN + '\'' +
         ", bookTitle='" + bookTitle + '\'' +
         ", bookAuthor='" + bookAuthor + '\'' +
         ", yearOfPublication='" + yearOfPublication.toString() + '\'' +
         ", publisher='" + publisher + '\'' +
         ", imageUrlMedium='" + imageUrlMedium + '\'' +
         '}';
   }



}