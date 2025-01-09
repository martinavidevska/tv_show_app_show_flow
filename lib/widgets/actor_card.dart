import 'package:flutter/material.dart';
import 'package:group_project/models/actor_model.dart';
import 'package:group_project/screens/actor_details.dart';

class ActorCard extends StatelessWidget {
  final Actor actor;

  const ActorCard({
    Key? key,
    required this.actor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActorDetailsScreen(actor: actor),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: actor.person.image?.medium != null
                ? NetworkImage(actor.person.image!.medium)
                : null, // Fallback to default color if image is null
            backgroundColor: Colors.grey.shade200,
            child: actor.person.image?.medium == null
                ? const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 40,
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            actor.person.name ,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            actor.character.name,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
