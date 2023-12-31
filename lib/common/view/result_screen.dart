import 'package:cost_simulator_client/common/const/colors.dart';
import 'package:cost_simulator_client/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HttpLink link = HttpLink('http://localhost:4000/');

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        home: DefaultLayout(
          backgroundColor: PRIMARY_COLOR,
          child: Home(),
          title: 'GraphQL Flutter Demo',
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  final String query = """
    query AllCosts {
      allCosts {
        id
        cost
        area
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(query),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }
        if (result.isLoading) {
          return Text('Loading');
        }
        List costs = result.data?['allCosts'];
        return ListView.builder(
          itemCount: costs.length,
          itemBuilder: (context, index) {
            final cost = costs[index];

            return ListTile(
              title: Text(cost["area"]),
              subtitle: Text(cost["cost"].toString()),
            );
          },
        );
      },
    );
  }
}
