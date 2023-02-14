export 'src/rating_bar.dart';
export 'src/rating_bar_indicator.dart';

/// THIS PACKAGE IS 99% THE SAME AS `flutter_rating_bar`.

/// Example 1:
/// ```dart
/// class MyHomePage extends StatefulWidget {
///   const MyHomePage({super.key, required this.title});
///   final String title;
/// 
///   @override
///   State<MyHomePage> createState() => _MyHomePageState();
/// }
/// 
/// class _MyHomePageState extends State<MyHomePage> {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: Text(widget.title),
///       ),
///       body: Container(
///         alignment: Alignment.center,
///         child: RatingBar.builder(
///           initialRating: 1,
///           itemCount: 3,
///           itemSize: (MediaQuery.of(context).size.width - 100)/3,
///           itemBuilder: (context, index) {
///             switch (index) {
///               case 0:
///                 return _buildRatingWidget(
///                     "assets/sad.svg", "Không hài lòng", Colors.red);
///               case 1:
///                 return _buildRatingWidget(
///                     "assets/smile.svg", "Bình thường", Color(0xFFE8C76A));
///               default:
///                 return _buildRatingWidget(
///                     "assets/big_smile.svg", "Hài lòng", Color.fromARGB(255, 13, 129, 21));
///             }
///           },
///           onRatingUpdate: (rating) {
///             print(rating);
///           },
///           isShowOnly1Rating: true,
///         ),
///       ),
///     );
///   }
/// 
///   Widget _buildRatingWidget(String assetPath, String description, Color color) {
///     return SizedBox(
///       child: Container(
///         height: 62,
///         alignment: Alignment.center,
///         child: Column(
///           mainAxisSize: MainAxisSize.min,
///           children: [
///             SvgPicture.asset(
///               assetPath,
///               width: 30,
///               height: 30,
///               color: color,
///             ),
///             SizedBox(height: 8),
///             Text(description, style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
/// 
/// Example 2:
/// ```dart
/// child: RatingBar(
///   initialRating: 1.5,
///   itemCount: 5,
///   onRatingUpdate: (value) {
///     print("hehe");
///   },
///   ratingWidget: RatingWidget(
///     full: Icon(Icons.star_rounded, color: Colors.amber),
///     empty: Icon(Icons.star_rounded, color: Colors.grey),
///     half: Icon(Icons.star_half_rounded, color: Colors.amber),
///   ),
///   allowHalfRating: true,
/// ),
/// ```
