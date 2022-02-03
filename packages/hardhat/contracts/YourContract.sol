pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

contract YourContract {
    struct tweet {
        string message;
        address owner;
        uint256 likes_count;
        mapping(address => bool) liker;
        mapping(uint256 => address) idToLiker;
    }
    struct user {
        string name;
        uint256 tweets_count;
        uint256 followers_count;
        uint256[] tweets;
        mapping(address => bool) followers;
        mapping(uint256 => address) idToFollower;
    }
    mapping(address => user) public addrToUser;
    mapping(uint256 => tweet) public gTweets;
    uint256 public gTweetsCount;

    function fTweet(string calldata _message) external {
        tweet storage t = gTweets[gTweetsCount];
        t.message = _message;
        t.owner = msg.sender;
        user storage u = addrToUser[msg.sender];
        u.tweets_count += 1;
        u.tweets.push(gTweetsCount);
        gTweetsCount += 1;
    }

    function fCreateUser(string memory _name) public {
        addrToUser[msg.sender].name = _name;
    }

    function follow(address _dest) external {
        user storage u = addrToUser[_dest];
        require(u.followers[msg.sender] == false, "Already Following");
        u.followers[msg.sender] = true;
        u.idToFollower[u.followers_count] = msg.sender;
        u.followers_count += 1;
    }

    function flike(uint256 _index) external {
        tweet storage t = gTweets[_index];
        require(t.liker[msg.sender] == false, "Already Liked");
        t.liker[msg.sender] = true;
        t.idToLiker[t.likes_count] = msg.sender;
        t.likes_count += 1;
    }

    function getFollowers(address _addr) external view returns(address[] memory) {
        user storage u = addrToUser[_addr];
        uint256 len = u.followers_count;
        address[] memory a = new address[](len);
        for(uint256 i=0; i < len; i++) {
            a[i] = u.idToFollower[i];
        }
        return a;
    }

    function getLikes(uint256 _index) external view returns(address[] memory) {
        require(_index < gTweetsCount, "invalid Tweet id");
        tweet storage t = gTweets[_index];
        uint256 len = t.likes_count;
        address[] memory a = new address[](len);
        for(uint256 i=0; i < len; i++) {
            a[i] = t.idToLiker[i];
        }
        return a;
    }
}


