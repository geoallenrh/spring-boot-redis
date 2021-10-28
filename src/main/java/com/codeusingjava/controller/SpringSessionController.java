package com.codeusingjava.controller;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.net.InetAddress;

import java.time.LocalTime;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class SpringSessionController {

	Logger logger = LoggerFactory.getLogger(SpringSessionController.class);

	@GetMapping("/")
	public String home(Model redisModel, HttpSession redisSession) {
		@SuppressWarnings("unchecked")
		List<String> messages = (List<String>) redisSession.getAttribute("REDIS_SESSION_MESSAGES");
		Integer counter = (Integer) redisSession.getAttribute("REDIS_SESSION_COUNTER");
		

		if (messages == null && counter == null ) {
			messages = new ArrayList<>();
			counter = new Integer(0);
			logger.info("Counter: " + counter);
		}

		redisModel.addAttribute("sessionMessages", messages);
		redisModel.addAttribute("sessionId", redisSession.getId());
		redisModel.addAttribute("counter", counter.toString());
		
		return "index";
	}

	@PostMapping("/persistMessage")
	public String persistMessage(@RequestParam("msg") String msg, HttpServletRequest redisRequest) {
		@SuppressWarnings("unchecked")
		List<String> msgs = (List<String>) redisRequest.getSession().getAttribute("REDIS_SESSION_MESSAGES");
		Integer counter = (Integer) redisRequest.getSession().getAttribute("REDIS_SESSION_COUNTER");
		if (msgs == null && counter == null) {
			msgs = new ArrayList<>();
			redisRequest.getSession().setAttribute("REDIS_SESSION_MESSAGES", msgs);
			msgs.add(msg);

			counter = new Integer(0);
			redisRequest.getSession().setAttribute("REDIS_SESSION_COUNTER", counter);
		}
		else {
		// do we want to use this?
		String oldMessage = msgs.get(0);
		counter = counter.intValue() + 1;
		logger.info("Counter: " + counter);
		String newMessage = msg + ":" + counter;
		msgs.set(0, newMessage);
		
		}


		logger.info("SessionID : " + redisRequest.getSession().getId());
		logger.info(getHostname() + ":" + msg);
		redisRequest.getSession().setAttribute("REDIS_SESSION_MESSAGES", msgs);
		redisRequest.getSession().setAttribute("REDIS_SESSION_COUNTER", counter);
		return "redirect:/";
	}

	@GetMapping("/counter")
	public String counter(HttpServletRequest redisRequest) {
		@SuppressWarnings("unchecked")
		
		Integer counter = (Integer) redisRequest.getSession().getAttribute("REDIS_SESSION_COUNTER");
		if (counter == null) {
		
			counter = new Integer(0);
			redisRequest.getSession().setAttribute("REDIS_SESSION_COUNTER", counter);
		}
		else {
		counter = counter.intValue() + 1;
		logger.info("Counter: " + counter);
		
		}

		logger.info("SessionID : " + redisRequest.getSession().getId());
		logger.info(getHostname() + ":" + counter);
		
		redisRequest.getSession().setAttribute("REDIS_SESSION_COUNTER", counter);
		return "redirect:/";
	}








	@PostMapping("/destroy")
	public String destroySession(HttpServletRequest redisRequest) {
		redisRequest.getSession().invalidate();
		logger.info("Session Invalidated");
		return "redirect:/";
	}

	private String getHostname() {

		// obtain a hostname. First try to get the host name from docker container (from the "HOSTNAME" environment variable)
		String hostName = System.getenv("HOSTNAME");

		// get the os name
		String os = System.getProperty("os.name");

		if(hostName == null || hostName.isEmpty()) {
			try {
				InetAddress addr = InetAddress.getLocalHost();
				hostName = addr.getHostName();
			} catch (Exception e) {
				System.err.println(e);
				hostName = "Unknow";
			}
		}
		return hostName;
	}
}