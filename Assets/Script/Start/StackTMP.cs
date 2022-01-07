using EraHF;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;

public class StackTMP : TMPBase
{
    private MessageStack messageStack;

    protected override void Awake()
    {
        base.Awake();
        messageStack = GetComponentInParent<MessageStack>();
        
    }

    protected override void LateUpdate()
    {
        try
        {
            if (isHoveringObject && !Active)
            {
                int wordIndex = TMP_TextUtilities.FindIntersectingWord(tmp, Input.mousePosition, camera);
                if (IsDebug)
                {
                    print("wordIndex  " + wordIndex);
                    print("selectedWord  " + selectedWord);
                }

                int linkIndex = TMP_TextUtilities.FindIntersectingLink(tmp, Input.mousePosition, camera);
                if (selectedWord != -1 && (wordIndex == -1 || wordIndex != selectedWord))
                {
                    TMP_WordInfo wInfo = tmp.textInfo.wordInfo[selectedWord];
                    // Iterate through each of the characters of the word.
                    for (int i = 0; i < wInfo.characterCount; i++)
                    {
                        int characterIndex = wInfo.firstCharacterIndex + i;

                        // Get the index of the material / sub text object used by this character.
                        int meshIndex = tmp.textInfo.characterInfo[characterIndex].materialReferenceIndex;

                        // Get the index of the first vertex of this character.
                        int vertexIndex = tmp.textInfo.characterInfo[characterIndex].vertexIndex;

                        // Get a reference to the vertex color
                        Color32[] vertexColors = tmp.textInfo.meshInfo[meshIndex].colors32;
                        if (IsDebug)
                        {
                            print("characterIndex" + characterIndex);
                            print("vertexColors.Length  " + vertexColors.Length);
                            print("vertexIndex  " + vertexIndex);
                        }
                        Color32 c = vertexColors[vertexIndex].Tint(1.33333f);

                        vertexColors[vertexIndex] = c;
                        vertexColors[vertexIndex + 1] = c;
                        vertexColors[vertexIndex + 2] = c;
                        vertexColors[vertexIndex + 3] = c;
                    }

                    // Update Geometry
                    tmp.UpdateVertexData(TMP_VertexDataUpdateFlags.All);

                    selectedWord = -1;
                }
                if (wordIndex != -1 && wordIndex != selectedWord && linkIndex != -1)
                {
                    selectedWord = wordIndex;
                    TMP_WordInfo wInfo = tmp.textInfo.wordInfo[wordIndex];
                    for (int i = 0; i < wInfo.characterCount; i++)
                    {
                        int characterIndex = wInfo.firstCharacterIndex + i;

                        // Get the index of the material / sub text object used by this character.
                        int meshIndex = tmp.textInfo.characterInfo[characterIndex].materialReferenceIndex;

                        int vertexIndex = tmp.textInfo.characterInfo[characterIndex].vertexIndex;

                        // Get a reference to the vertex color
                        Color32[] vertexColors = tmp.textInfo.meshInfo[meshIndex].colors32;

                        Color32 c = vertexColors[vertexIndex + 0].Tint(0.75f);

                        vertexColors[vertexIndex + 0] = c;
                        vertexColors[vertexIndex + 1] = c;
                        vertexColors[vertexIndex + 2] = c;
                        vertexColors[vertexIndex + 3] = c;
                    }
                    tmp.UpdateVertexData(TMP_VertexDataUpdateFlags.All);
                }
            }
        }
        catch (IndexOutOfRangeException e)
        {
            Debug.Log(e);
        }

    }

    public override void OnPointerDown(PointerEventData eventData)
    {
        if (!Active)
        {
            int linkIndex = TMP_TextUtilities.FindIntersectingLink(tmp, Input.mousePosition, camera);
            if (linkIndex != -1)
            {

                TMP_LinkInfo linkInfo = tmp.textInfo.linkInfo[linkIndex];

                // Debug.Log("Link ID: \"" + linkInfo.GetLinkID() + "\"   Link Text: \"" + linkInfo.GetLinkText() + "\""); // Example of how to retrieve the Link ID and Link Text.

                Vector3 worldPointInRectangle;

                RectTransformUtility.ScreenPointToWorldPointInRectangle(tmp.rectTransform, Input.mousePosition, camera, out worldPointInRectangle);

                GameManager.Instance.ClickHandle(linkInfo.GetLinkID());
                if (IsOnce)
                {
                    GameManager.Instance.MessageStack.DelButton();
                }
            }
            else if(!messageStack.Wait)
            {
                messageStack.PushMessage();
            }

        }
    }
}
