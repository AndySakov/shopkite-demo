import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HyperlinkDialog extends StatelessWidget {
  const HyperlinkDialog({Key? key}) : super(key: key);

  Widget hyperLink(String text, String url) {
    return Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
            child: Text(
              text,
              style: const TextStyle(
                  decoration: TextDecoration.underline, color: Colors.blue),
            ),
            onTap: () => launch(url)),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              'Hyperlink Demo',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black54),
            ),
          ),
          const Divider(
            color: Colors.deepOrangeAccent,
            height: 20,
            thickness: 2,
          ),
          hyperLink('Shopkite Website', 'https://shopkite.com.ng'),
          hyperLink('Google Home Page', 'https://google.com.ng'),
          hyperLink('Github', 'https://github.com'),
          hyperLink('Facebook', 'https://facebook.com'),
          hyperLink('Instagram', 'https://instagram.com'),
          hyperLink('Twitch', 'https://twitch.tv'),
          const Divider(
            color: Colors.deepOrangeAccent,
            height: 20,
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Close'),
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              ),
            ],
          )
        ],
      ),
      height: 365,
    );
  }
}
