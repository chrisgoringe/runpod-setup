from comfy_things import  modify_widget, delete_node, queue_prompt

def main():
    changes = [
        modify_widget(170, "string", TRAINING_IMAGES_CLASS_TOKEN),  
        modify_widget(172, "int",    STEPS_PER_PHASE),   
        modify_widget(204, "string", NAME),
        modify_widget(219, "class_tokens", REGULARISATION_IMAGES_CLASS_TOKEN),
    ]
    if RESTARTING:  changes.append( modify_widget(226, "y", RESTARTING ) )
    else:           changes.append( delete_node(148) )

    queue_prompt(jsonfile='training.json', make_changes=changes, wait_after=True)     

NAME = "rb4"
STEPS_PER_PHASE = 500
RESTARTING = "02000"
TRAINING_IMAGES_CLASS_TOKEN = ""
REGULARISATION_IMAGES_CLASS_TOKEN = ""

if __name__=='__main__': 
    main()
