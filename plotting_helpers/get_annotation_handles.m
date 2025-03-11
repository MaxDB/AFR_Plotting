function annotations = get_annotation_handles(fig)
annotations = findall(fig,'Tag','scribeOverlay');
end