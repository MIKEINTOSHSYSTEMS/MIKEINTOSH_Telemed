import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;

  HtmlWidget({this.postContent, this.color});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: postContent,
      onLinkTap: (s, _, __) {
        commonLaunchUrl(s!, launchMode: LaunchMode.externalApplication);
      },
      style: {
        'embed': Style(color: color ?? transparentColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: FontSize(16)),
        'strong': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'a': Style(color: color ?? Colors.blue, fontWeight: FontWeight.bold, fontSize: FontSize(16)),
        'div': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'figure': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h1': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h2': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h3': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h4': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h5': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'h6': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'ol': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'ul': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'strike': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'u': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'b': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'i': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'hr': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'header': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'code': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'data': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'body': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'big': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'blockquote': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(16)),
        'img': Style(
          width: Width(context.width()),
         // padding: HtmlPaddings(bottom: 8), // Use HtmlPaddings constructor
          fontSize: FontSize(16),
        ),
      },
      /* customRender: {
        "embed": (RenderContext renderContext, Widget child) {
          var videoLink = renderContext.parser.htmlData.text.splitBetween('<embed>', '</embed');

          if (videoLink.contains('yout')) {
            return YouTubeEmbedWidget(videoLink.replaceAll('<br>', '').convertYouTubeUrlToId());
          } else if (videoLink.contains('vimeo')) {
            return VimeoEmbedWidget(videoLink.replaceAll('<br>', ''));
          } else {
            return child;
          }
        },
        "figure": (RenderContext renderContext, Widget child) {
          if (renderContext.parser.htmlData.documentElement!.innerHtml.contains('yout')) {
            return YouTubeEmbedWidget(renderContext.parser.htmlData.documentElement!.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').convertYouTubeUrlToId());
          } else if (renderContext.parser.htmlData.documentElement!.innerHtml.contains('vimeo')) {
            return VimeoEmbedWidget(renderContext.parser.htmlData.documentElement!.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').splitAfter('com/'));
          } else {
            return child;
          }
        },
      }*/
    );
  }
}
