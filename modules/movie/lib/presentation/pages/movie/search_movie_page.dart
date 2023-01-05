import 'package:core/common/constants.dart';
import 'package:movie/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:movie/presentation/pages/movie/movie_detail_page.dart';
import 'package:core/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/search/movie';

  const SearchMoviePage({Key? key}) : super(key: key);

  @override
  State<SearchMoviePage> createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
        () => context.read<SearchMovieBloc>().add(OnSearchMovieInitState()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context
                    .read<SearchMovieBloc>()
                    .add(OnSearchMovieQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchMovieBloc, SearchMovieState>(
              builder: (context, state) {
                if (state is SearchMovieLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchMovieHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = state.result[index];
                        return ItemCard(
                          item: ItemData(
                              title: movie.title,
                              overview: movie.overview,
                              posterPath: movie.posterPath),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              MovieDetailPage.ROUTE_NAME,
                              arguments: movie.id,
                            );
                          },
                        );
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchMovieError) {
                  return Expanded(
                    child: Container(),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
