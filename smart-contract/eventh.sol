pragma solidity ^0.4.0;


contract eventh {

    //Create the ticket
    struct Ticket {
        string tName; //Name of the event
        uint8 tNumber; //Asigns a ID number for the ticket
        uint256 tValue; //Value for the ticket
        bool tFree; //Indicates if the events is free or not.
        bool tSold; //Checks if the ticket has been sold
        bool tPunched; //Activated when the assistant go to the event
    }

                         /// ----- VARIABLES ----- ///

    address public organiser; //Identifing the owner a.k. as the organizer
    string public eventName; //Event name, could be changed for an ID
    uint256 public value; //We will use value to define the price of the ticket ADJUST!
    bool public eventFree; //Set if the event is free or not
    uint8 public totalTickets; //total number of tickets
    uint8 public issuedTickets; //Tickets sold
    mapping(address => Ticket) assistants; //List of assistants

    ///WE NEED A EVENT DATE VARIABLE TO MAKE THIS CONTRACT WORK BETTER!!!!!!!

    //Contract creators addresses
    address public creatorAM;

                        /// ----- MODIFIERS ----- ///

    modifier onlyOrganiser {
        require(msg.sender == organiser);
        _;
    }

                        /// ----- CONTRACT CREATION ----- ///

    constructor (string _eventName, uint256 _value, bool _eventFree, uint8 _totalTickets) public payable {

        //require(msg.value == 1 ether);

         //The organiser is the one that creates the contract
        organiser = msg.sender;
        eventName = _eventName;
        value = _value;
        eventFree = _eventFree;
        totalTickets = _totalTickets;
        issuedTickets = 0;

        //Reference creator:
        creatorAM = 0xeCdBEEf1027bD42983c35DB6F5feaEC1B7522FaE;
    }//constructor


                        /// ----- USER REQUEST TICKET ----- ///

    function takeTicket() payable{

        address assistant = msg.sender;
        require(msg.value == 1 ether); //pay for the ticket

        //Check if the sender already has purchased a ticket. If not issue one
        //We also should avoid the organiser buy a ticket. ?
        if(assistants[assistant].tSold != true) {

            //Issue the ticket if there are tickets left
            if(issuedTickets<totalTickets){
                issuedTickets++;
                Ticket memory ticket = Ticket(eventName,issuedTickets,value,eventFree,true,false);
                assistants[assistant] = ticket;
            }else{
                assistant.transfer(1 ether);
            }//if not inform that there are no tickets left and return ether

        }else{
            assistant.transfer(1 ether);
        }//if not inform the user that already has a ticketand return ether
    }//takeTicket

                    /// ----- ORGANISER CHECKS ATTENDANCE ----- ///

    //It would be nice to only let the organoiser do that the day of the event
    function isHere(address _assistant) onlyOrganiser {

        //After chechk that the address has a valid ticket and has not been punched:
         if(assistants[_assistant].tSold == true && assistants[_assistant].tPunched == false) {
             assistants[_assistant].tPunched = true; //Punch the ticket
             if(eventFree == true){
                _assistant.transfer(1 ether); //return the ether deposit to the assistant
             }//just if the event is free
         }
    }//isHere

                     /// ----- EVENT HAS END ----- ///

    //The idea here is to end with the contract after a few days of the event date.
    //Then, the ethers that are in the conctract, due to people that has not assisted
    //will be send to the organizer account and the creator of the contract as a gesture
    //of greeting for the creation of this contract. The split will change if we are on
    //a free or a paid event. It could be something like:
    //Free event: 50% for creators
    //Paid event: 5% for creators


                     /// ----- QUALITY CONTROL ----- ///

    //Assistant can leave a puntuation after the workshop, if a significant numbers
    //of reviews indicate that something is wrong some things can change.

    
                /// ----- CANCEL THE EVENT BY ORGANIZER ----- ///

    //If the event is cancelled the organizer can execute this function that will
    //refund the ether to the assistants.

                 /// -----     GET REFUND BY USER    ----- ///

    //We can make the event refundable letting the user cancel the ticket X days
    //before the event date.


}//
