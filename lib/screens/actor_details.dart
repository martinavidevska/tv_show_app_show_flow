import 'package:flutter/material.dart';
import 'package:group_project/models/actor_model.dart';

class ActorDetailsScreen extends StatelessWidget {
  final Actor actor;
  const ActorDetailsScreen({
    super.key,
   required this.actor,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF273343),
      appBar: AppBar(
      backgroundColor: const Color(0xFF273343),
      iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
               height: 40,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Actor Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(actor.person.image.medium),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actor.person.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(actor.person.birthday ?? 'no info',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(actor.person.country?.name ?? 'unknown', style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),

                  const Text(
                    'Known For... Comming soon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
