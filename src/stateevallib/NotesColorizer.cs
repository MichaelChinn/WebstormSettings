using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StateEval
{
       //element is the whole element
        //tag is something between '<' and '>', which might be an element
 
    public class Tag
    {
        public const char STOPCHAR = '>';
        public const char STARTCHAR = '<';
        string _tagInnerText = "";//is the word with the slash, if any
        string _tagType = "";     //is just the word
        string _tagText = "";

        int _lAt = 0;
        int _gAt = 0;

        public Tag(ref string s, int iStart)
        {
            _lAt = iStart;
            
            //iStart points to '<'
            _gAt = s.IndexOf(STOPCHAR, _lAt);
            _tagText = s.Substring(_lAt, _gAt - _lAt + 1);
            _tagInnerText = _tagText.Trim(new char[] { '<', '>' });
            _tagType = _tagInnerText.Trim(new char[] { '/',' '});

        }
        public string Type { get { return _tagType; } }
        public string Text { get { return _tagText; } }
        public bool TagIsSelfContainedEll { get { return _tagInnerText.EndsWith("/") ? true : false; } }
        public bool IsStartTag { get { return !_tagInnerText.StartsWith("/"); } }
        public bool IsEndTag { get { return _tagInnerText.StartsWith("/"); } }
        public bool IsEndOf(Tag tagToMatch)
        {
            if (tagToMatch.IsEndTag)
                return false;

            return this.Type == tagToMatch.Type;
        }
        public int TagStartIndex { get { return _lAt; } }
        public int TagEndIndex { get { return _gAt; } }
    }

    public class NotesColorizer
    {
        string _text;
        string _spanStartText;
        string _spanEndText = "</span>";
        Stack<Tag> _tagStack = new Stack<Tag>();
        public NotesColorizer(string s, string color)
        {
            _text = s;
            _spanStartText = "<span style=\"background-color: " + color.ToLower() + ";\">";
        }

        public int NextTagStart(int startSearchAt) { return _text.IndexOf(Tag.STARTCHAR, startSearchAt); }
        public int NextTagEnd(int startSearchAt) { return _text.IndexOf(Tag.STOPCHAR, startSearchAt); }

        public int StartNextSearchAt(int lastIndex)
        {
            int i = NextTagEnd(lastIndex);
            if (i < 0)
                throw (new Exception("badly formed xml; string: " + _text + "... at: " + i.ToString()));

            return i++;
        }

        public int LoadStack()
        {
            int i = 0;
            while (i > -1)
            {
                i = NextTagStart(i);
                if (i == -1)
                    continue;

                Tag tag = new Tag(ref _text, i);

                if (tag.TagIsSelfContainedEll)
                    continue;

                if (_tagStack.Count == 0)
                {
                    _tagStack.Push(tag);
                    i = StartNextSearchAt(i);
                    continue;
                }

                Tag lastTag = _tagStack.Peek();
                if (tag.IsEndOf(lastTag))
                {
                    _tagStack.Pop();
                    i = StartNextSearchAt(i);
                    continue;
                }

                _tagStack.Push(tag);
                i = StartNextSearchAt(i);

            }
            return _tagStack.Count;
        }
        public string GetChunk(int start, int stop)
        {
            return _text.Substring(start, stop - start + 1);
        }
        public void AddColorizedFrag(StringBuilder sb, int contentStart, int contentEnd, Tag tag)
        {
            sb.Append(GetChunk(contentStart, contentEnd));
            sb.Append(_spanEndText);

            sb.Append(GetChunk(tag.TagStartIndex, tag.TagEndIndex));
            sb.Append(_spanStartText);
        }
        
        public string Colorized
        {
            get
            {
               StringBuilder sb = new StringBuilder();
                sb.Append(_spanStartText);
                int lastEndTagStopPosition = -1;

                if (LoadStack() > 0)
                {
                    Stack<Tag> reverseTags = new Stack<Tag>();
                    while (_tagStack.Count > 0)
                    {
                        reverseTags.Push(_tagStack.Pop());
                    }

                    if (reverseTags.Count > 0)
                    {
                        do
                        {
                            Tag t = reverseTags.Pop();

                            AddColorizedFrag(sb, lastEndTagStopPosition + 1, t.TagStartIndex - 1, t);

                            lastEndTagStopPosition = t.TagEndIndex;
                        }
                        while (reverseTags.Count > 0);
                    }
                }
                sb.Append(GetChunk(lastEndTagStopPosition + 1, _text.Length - 1));
                sb.Append(_spanEndText);

                return sb.ToString();
            }
        }
        public string BeginTag { get{return _spanStartText;}set { _spanStartText = value; } }
        public string EndTag { get { return _spanEndText; } set { _spanEndText = value; } }
    }
}
